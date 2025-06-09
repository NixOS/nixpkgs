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
  version = "2.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XCHRKwUEm1Amoth0ekzYCwe5rmG4mLXcZiSXzHsbmTU=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
