{ lib
, buildPythonPackage
, fetchFromGitHub
, scikit-build-core
, pybind11
, cmake
, LASzip
, pythonOlder
}:

buildPythonPackage rec {
  pname = "laszip-python";
  version = "0.2.1";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tmontaigu";
    repo = pname;
    rev = version;
    hash = "sha256-ujKoUm2Btu25T7ZrSGqjRc3NR1qqsQU8OwHQDSx8grY=";
  };

  nativeBuildInputs = [
    cmake
    pybind11
    scikit-build-core
    scikit-build-core.optional-dependencies.pyproject
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    LASzip
  ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "laszip" ];

  meta = with lib; {
    description = "Unofficial bindings between Python and LASzip made using pybind11";
    homepage = "https://github.com/tmontaigu/laszip-python";
    changelog = "https://github.com/tmontaigu/laszip-python/blob/${src.rev}/Changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}

