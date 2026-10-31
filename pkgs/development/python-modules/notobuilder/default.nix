{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  setuptools,
  setuptools-scm,
  fonttools,
  ufomerge,
  fontmake,
  glyphslib,
  ttfautohint-py,
  ufo2ft,
  gftools,
  fontbakery,
  chevron,
  sh,
  font-v,
  ninja,
  writers,
  pyyaml,
  replaceVars,
}:

let
  patchConfig = writers.writePython3Bin "notobuilder-patch-config" {
    libraries = [
      pyyaml
    ];
  } (builtins.readFile ./patchConfig.py);
in
buildPythonPackage {
  pname = "notobuilder";
  version = "0-unstable-2026-09-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "efda64ea4bdb249cfa69cad28d9cf2febfc7b0c8";
    hash = "sha256-xAddENwuFPc3Yk0xqWZKbnUAdj3Ka7hoOl+YmYSh3XI=";
  };

  patches = [
    ./build-bin.patch
  ];

  postPatch = ''
    substituteInPlace Lib/notobuilder/__main__.py \
      --replace-fail '"ninja"' '"${lib.getExe ninja}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.0.0";

  dependencies = [
    fonttools
    ufomerge
    fontmake
    glyphslib
    ttfautohint-py
    ufo2ft
    gftools
    fontbakery
    chevron
    sh
    font-v
  ]
  ++ gftools.optional-dependencies.qa;

  pythonImportsCheck = [
    "notobuilder"
    "notoqa"
  ];

  setupHook = replaceVars ./setup-hook.sh {
    patchConfig = lib.getExe patchConfig;
  };

  passthru = {
    inherit patchConfig;
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Python module for building Noto fonts";
    homepage = "https://github.com/notofonts/notobuilder";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
