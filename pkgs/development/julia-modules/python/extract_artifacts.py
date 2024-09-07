
import json
from pathlib import Path
import multiprocessing
import subprocess
import sys
import toml
from urllib.parse import urlparse
import yaml

import dag

# This should match the behavior of the default unpackPhase.
# See https://github.com/NixOS/nixpkgs/blob/59fa082abdbf462515facc8800d517f5728c909d/pkgs/stdenv/generic/setup.sh#L1044
archive_extensions = [
  # xz extensions
  ".tar.xz",
  ".tar.lzma",
  ".txz",

  # *.tar or *.tar.*
  ".tar",
  ".tar.Z",
  ".tar.bz2",
  ".tar.gz",

  # Other tar extensions
  ".tgz",
  ".tbz2",
  ".tbz",

  ".zip"
  ]

dependencies_path = Path(sys.argv[1])
closure_yaml_path = Path(sys.argv[2])
julia_path = Path(sys.argv[3])
extract_artifacts_script = Path(sys.argv[4])
extra_libs = json.loads(sys.argv[5])
out_path = Path(sys.argv[6])

with open(dependencies_path, "r") as f:
  dependencies = yaml.safe_load(f)
  dependency_uuids = dependencies.keys()

with open(closure_yaml_path, "r") as f:
  # Build up a map of UUID -> closure information
  closure_yaml_list = yaml.safe_load(f) or []
  closure_yaml = {}
  for item in closure_yaml_list:
    closure_yaml[item["uuid"]] = item

  # Build up a dependency graph of UUIDs
  closure_dependencies_dag = dag.DAG()
  for uuid, contents in closure_yaml.items():
    if contents.get("depends_on"):
      closure_dependencies_dag.add_node(uuid, dependencies=contents["depends_on"].values())

def get_archive_derivation(uuid, artifact_name, url, sha256):
  depends_on = set()
  if closure_dependencies_dag.has_node(uuid):
    depends_on = set(closure_dependencies_dag.get_dependencies(uuid)).intersection(dependency_uuids)

  other_libs = extra_libs.get(uuid, [])

  fixup = f"""fixupPhase = let
          libs = lib.concatMap (lib.mapAttrsToList (k: v: v.path))
                               [{" ".join(["uuid-" + x for x in depends_on])}];
          in ''
            find $out -type f -executable -exec \
              patchelf --set-rpath \$ORIGIN:\$ORIGIN/../lib:${{lib.makeLibraryPath (["$out" glibc] ++ libs ++ (with pkgs; [{" ".join(other_libs)}]))}} {{}} \;
            find $out -type f -executable -exec \
              patchelf --set-interpreter ${{glibc}}/lib/ld-linux-x86-64.so.2 {{}} \;
          ''"""

  return f"""stdenv.mkDerivation {{
        name = "{artifact_name}";
        src = fetchurl {{
          url = "{url}";
          sha256 = "{sha256}";
        }};
        preUnpack = ''
          mkdir unpacked
          cd unpacked
        '';
        sourceRoot = ".";
        dontConfigure = true;
        dontBuild = true;
        installPhase = "cp -r . $out";
        {fixup};
      }}"""

def get_plain_derivation(url, sha256):
  return f"""fetchurl {{
        url = "{url}";
        sha256 = "{sha256}";
      }}"""

with open(out_path, "w") as f:
  f.write("{ lib, fetchurl, glibc, pkgs, stdenv }:\n\n")
  f.write("rec {\n")

  def process_item(item):
    uuid, src = item
    lines = []
    artifacts = toml.loads(subprocess.check_output([julia_path, extract_artifacts_script, uuid, src]).decode())
    if not artifacts: return f'  uuid-{uuid} = {{}};\n'

    lines.append(f'  uuid-{uuid} = {{')

    for artifact_name, details in artifacts.items():
      if len(details["download"]) == 0: continue
      download = details["download"][0]
      url = download["url"]
      sha256 = download["sha256"]

      git_tree_sha1 = details["git-tree-sha1"]

      parsed_url = urlparse(url)
      if any(parsed_url.path.endswith(x) for x in archive_extensions):
        derivation = get_archive_derivation(uuid, artifact_name, url, sha256)
      else:
        derivation = get_plain_derivation(url, sha256)

      lines.append(f"""    "{artifact_name}" = {{
      sha1 = "{git_tree_sha1}";
      path = {derivation};
    }};\n""")

    lines.append('  };\n')

    return "\n".join(lines)

  with multiprocessing.Pool(10) as pool:
    for s in pool.map(process_item, dependencies.items()):
      f.write(s)

  f.write(f"""
}}\n""")
