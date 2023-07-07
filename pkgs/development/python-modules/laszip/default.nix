{ lib
, buildPythonPackage
, fetchFromGitHub
, scikit-build-core
, distlib
, pytestCheckHook
, pyproject-metadata
, pathspec
, pybind11
, cmake
, LASzip
}:

buildPythonPackage rec {
  pname = "laszip-python";
  version = "0.2.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmontaigu";
    repo = pname;
    rev = version;
    sha256 = "sha256-ujKoUm2Btu25T7ZrSGqjRc3NR1qqsQU8OwHQDSx8grY=";
  };

  nativeBuildInputs = [
    scikit-build-core
    scikit-build-core.optional-dependencies.pyproject
    cmake
  ];

  buildInputs = [
    pybind11
    LASzip
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    cd ..
  '';

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "laszip" ];

  meta = with lib; {
    description = "Unofficial bindings between Python and LASzip made using pybind11";
    homepage = "https://github.com/tmontaigu/laszip-python";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}

