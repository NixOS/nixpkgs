{ lib
, buildPythonPackage
, fetchFromGitHub
, cryptography
, dictdiffer
, grpcio
, protobuf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygnmi";
  version = "0.8.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "akarneliuk";
    repo = "pygnmi";
    rev = "v${version}";
    sha256 = "sha256-5dAjN/HDFKQmJIjhergBjSmHQKhBxqy/Jneh1pLCHrw=";
  };

  propagatedBuildInputs = [
    cryptography
    dictdiffer
    grpcio
    protobuf
  ];

  # almost all tests fail with:
  # TypeError: expected string or bytes-like object
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pygnmi" ];

  meta = with lib; {
    description = "Pure Python gNMI client to manage network functions and collect telemetry";
    homepage = "https://github.com/akarneliuk/pygnmi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
