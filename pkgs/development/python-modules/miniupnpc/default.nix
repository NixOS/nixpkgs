{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  cctools,
  which,
}:

buildPythonPackage rec {
  pname = "miniupnpc";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AvnUqth2igy4xGvDC+C6jOwUi2005NDvmfrbec+JrzE=";
  };

  patches = [
    # TODO: remove this patch when updating to the next release
    (fetchpatch {
      url = "https://github.com/miniupnp/miniupnp/commit/f79ae6738d10af633844dcf3ecd9c587e8f9508d.patch";
      stripLen = 1;
      hash = "sha256-g+D9Cw5knTy5a7M0wAQkw8MZ6iZR8RQUT6A0WAc6Q5U=";
    })
  ];

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
