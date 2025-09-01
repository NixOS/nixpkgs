{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  djvulibre,
  setuptools,
  ghostscript_headless,
  pkg-config,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-djvulibre";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "python-djvulibre";
    tag = version;
    hash = "sha256-ntDRntNxVchZm+i+qBbiZlfHAXJRKMin9Hi+BoJQjTM=";
  };

  build-system = [
    cython
    djvulibre
    ghostscript_headless
    pkg-config
    setuptools
  ];

  dependencies = [
    djvulibre
    ghostscript_headless
  ];

  preCheck = ''
    rm -rf djvu
    rm -rf tests/examples
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "tests"
    "-v"
  ];

  meta = with lib; {
    description = "Python support for the DjVu image format";
    homepage = "https://github.com/FriedrichFroebel/python-djvulibre";
    license = licenses.gpl2Only;
    changelog = "https://github.com/FriedrichFroebel/python-djvulibre/releases/tag/${src.tag}";
    maintainers = with maintainers; [ dansbandit ];
  };
}
