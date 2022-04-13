{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, cmake
, ninja
, cython
, scikit-build
, setuptools
, rapidfuzz-cpp
, rapidfuzz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "levenshtein";
  version = "0.18.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-WREYdD5MFOpCzH4BSceRpzQZdpi3Xxxn0DpMvDsNlGo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", < 3.0.0" ""

    substituteInPlace pyproject.toml \
      --replace "Cython==3.0.0a10" "Cython>=0.29.0"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    cython
    scikit-build
    setuptools
  ];

  buildInputs = [
    rapidfuzz-cpp
  ];

  propagatedBuildInputs = [
    rapidfuzz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${python.pkgs.scikit-build}/${python.sitePackages}/skbuild/resources/cmake"
  ];

  pythonImportsCheck = [
    "Levenshtein"
  ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
