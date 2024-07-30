{
  setuptools,
  mkdocs,
  mkdocs-macros,
  mkdocs-material,
  runCommand,
  callPackage,
}:

let
  inherit (mkdocs-macros) pname version src;

  mkdocs-macros-test = callPackage ./mkdocs-macros-test.nix { };

  env = {
    nativeBuildInputs = [
      setuptools
      mkdocs
      mkdocs-macros
      mkdocs-macros-test
      mkdocs-material
    ];
  };
in
runCommand "mkdocs-macros-example-docs" env ''
  set -euo pipefail
  mkdir $out

  base_dir=${pname}-${version}/test
  tar --extract "--file=${src}"

  for test_dir in $base_dir/*/; do
    pushd $test_dir
    mkdocs build --site-dir=$out/$test_dir
    popd
  done

  # Do some static checks on the generated content
  pushd $out/$base_dir
  # Non-existent variables
  cat debug/index.html | grep "another one:  that"
  # File inclusion
  cat module/index.html | grep "part from an <em>included</em> file!"
  # Variable replacement
  cat module_dir/index.html | grep "total costs is 50 euros"
  # New syntax with square brackets
  cat new_syntax/index.html | grep "expensive"
  # General info on macros
  cat simple/index.html | grep "Macros Plugin Environment"
''
