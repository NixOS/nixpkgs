{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-grpc";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-C9JoP/00GZRE1wfAqwGXCyLgr7umyx3bbVeMhev+Cb0=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ grpcio ];

  meta = {
    description = "Pytest plugin for grpc";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = lib.licenses.mit;
  };
})
