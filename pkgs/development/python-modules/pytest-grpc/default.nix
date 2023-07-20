{ lib
, buildPythonPackage
, fetchPypi
, grpcio
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-grpc";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C9JoP/00GZRE1wfAqwGXCyLgr7umyx3bbVeMhev+Cb0=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    grpcio
  ];

  meta = with lib; {
    description = "pytest plugin for grpc";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = teams.deshaw.members;
  };
}
