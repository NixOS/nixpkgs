{ buildPythonPackage
, fetchPypi
, lib
, msgpack
, greenlet
, pythonOlder
, isPyPy
, pytest-runner
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.3";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OnlTeL3l6AkvvrOhqZvpxhPSaFVC8dsOXG/UZ+7Vbf8=";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  # Tests require pkgs.neovim,
  # which we cannot add because of circular dependency.
  doCheck = false;

  propagatedBuildInputs = [ msgpack ]
    ++ lib.optional (!isPyPy) greenlet;

  meta = {
    description = "Python client for Neovim";
    homepage = "https://github.com/neovim/python-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
