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
  version = "0-unstable-2025-08-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "notobuilder";
    rev = "fb0d6067beee888e6132b50c227da1f051b1ef9f";
    hash = "sha256-U9NVpXzdzBpgs8LFQJk70vs2dfHg+kD+YzuYZt6zQ5g=";
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
