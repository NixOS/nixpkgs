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
}:

buildPythonPackage {
  pname = "notobuilder";
  version = "0-unstable-2026-01-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "0fa2bd755e02d57630d1f5ff7cda965454e68022";
    hash = "sha256-ZqB/jv3KwRIiZST2Ghe3DLxnfeRDpx83LooCAdYwh5E=";
  };

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

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python module for building Noto fonts";
    homepage = "https://github.com/notofonts/notobuilder";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
