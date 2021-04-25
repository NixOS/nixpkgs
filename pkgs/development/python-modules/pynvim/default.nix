{ buildPythonPackage
, fetchPypi
, lib
, nose
, msgpack
, greenlet
, trollius ? null
, pythonOlder
, isPyPy
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OnlTeL3l6AkvvrOhqZvpxhPSaFVC8dsOXG/UZ+7Vbf8=";
  };

  nativeBuildInputs = [
    pytestrunner
  ];

  # Tests require pkgs.neovim,
  # which we cannot add because of circular dependency.
  doCheck = false;

  propagatedBuildInputs = [ msgpack ]
    ++ lib.optional (!isPyPy) greenlet
    ++ lib.optional (pythonOlder "3.4") trollius;

  meta = {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/python-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
