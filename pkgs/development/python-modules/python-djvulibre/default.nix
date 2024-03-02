{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, djvulibre
, ghostscript_headless
, packaging
, pkg-config
, requests
, setuptools
, unittestCheckHook
, wheel
}:

buildPythonPackage rec {
  pname = "python-djvulibre";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FriedrichFroebel";
    repo = "python-djvulibre";
    rev = version;
    hash = "sha256-OrOZFvzDEBwBmIc+i3LjNTh6K2vhe6NWtSJrFTSkrgA=";
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

  unittestFlagsArray = [ "tests" "-v" ];

  meta = with lib; {
    description = "Python support for the DjVu image format";
    homepage = "https://github.com/FriedrichFroebel/python-djvulibre";
    license = licenses.gpl2Only;
    changelog = "https://github.com/FriedrichFroebel/python-djvulibre/releases/tag/${version}";
    maintainers = with maintainers; [ dansbandit ];
  };
}
