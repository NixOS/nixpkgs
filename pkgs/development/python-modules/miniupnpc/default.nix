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

<<<<<<< HEAD
  meta = {
    description = "MiniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
=======
  meta = with lib; {
    description = "MiniUPnP client";
    homepage = "http://miniupnp.free.fr/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
