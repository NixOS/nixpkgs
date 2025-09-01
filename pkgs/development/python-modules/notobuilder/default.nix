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
  version = "0-unstable-2025-05-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "ff46ffb2e19ff8e8c36a4e3e0db334bb249896cb";
    hash = "sha256-K4F+Et50QVXOOk00u/8ZXKj/TWoC6ndCeAF9jaMD7jI=";
  };

  postPatch = ''
    substituteInPlace Lib/notobuilder/__main__.py \
      --replace-fail '"ninja"' '"${lib.getExe ninja}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    ufomerge
    fontmake
    glyphslib
    ttfautohint-py
    ufo2ft
    gftools
    fontbakery
    diffenator2
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
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
