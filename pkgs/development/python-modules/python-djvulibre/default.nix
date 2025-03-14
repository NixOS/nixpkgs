{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  djvulibre,
  ghostscript_headless,
  packaging,
  pkg-config,
  setuptools,
  unittestCheckHook,
  wheel,
}:

buildPythonPackage rec {
  pname = "python-djvulibre";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "python-djvulibre";
    tag = version;
    hash = "sha256-5jOJyVPGJvR4YgxgJgyN47/OzsK3ASJXfn1Gt9y8rbs=";
  };

  nativeBuildInputs = [
    cython
    packaging
    pkg-config
    setuptools
    wheel
  ];

  buildInputs = [
    djvulibre
    ghostscript_headless
  ];

  preCheck = ''
    rm -rf djvu
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
