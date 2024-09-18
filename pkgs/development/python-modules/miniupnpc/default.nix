{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  cctools,
  which,
}:

buildPythonPackage rec {
  pname = "miniupnpc";
  version = "2.2.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KwpNVl+tZTZHHZKW9p3a/S0nZJW6lZftjBK9ECkRUMo=";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    cctools
    which
  ];

  meta = with lib; {
    description = "miniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
