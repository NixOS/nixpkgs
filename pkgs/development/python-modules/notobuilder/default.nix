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
  diffenator2,
  chevron,
  sh,
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
  version = "0-unstable-2026-02-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "5c15f266be1f24587adad807e2f1f3ff9ff537a8";
    hash = "sha256-Tw1riTHORtIpOq8PjSspIR044TBupYgXkI8fBiBkgJI=";
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
