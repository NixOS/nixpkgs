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
  version = "0-unstable-2024-09-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "8a60f1599ce86c4b3eacb5d01c3f17162bab67d3";
    hash = "sha256-YBiDOnt2B7I/AcEfFgGrdzN/tNz/tQO0cv9N4PupPCE=";
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
  ] ++ gftools.optional-dependencies.qa;

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
