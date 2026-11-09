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
  pyyaml,
  ninja,
}:

buildPythonPackage {
  pname = "notobuilder";
  version = "0-unstable-2026-10-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "a5b5b0435705b4bdc30e291e827a7c11cc15bd1a";
    hash = "sha256-jP2gxWzKCZAF4tnvb45dqsh1WpGVGfi5xOTH6zwzftY=";
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
    font-v
    pyyaml
  ]
  ++ gftools.optional-dependencies.qa;

  pythonRelaxDeps = [
    "chevron"
  ];

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
