{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cctools,
  which,
}:

buildPythonPackage rec {
  pname = "miniupnpc";
  version = "2.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7l6Vffgo0vocw2TmDFg9EEOREIiPCGyRggcclqN0sq0=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    which
  ];

  meta = with lib; {
    description = "MiniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
