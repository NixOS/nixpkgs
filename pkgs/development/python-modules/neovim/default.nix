{ buildPythonPackage
, fetchPypi
, lib
, nose
, msgpack
, greenlet
, trollius
, pythonOlder
, isPyPy
}:

buildPythonPackage rec {
  pname = "neovim";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6a0e7a5b4433bf4e6ddcbc5c5ff44170be7d84259d002b8e8d8fb4ee78af60f";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

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
    maintainers = with lib.maintainers; [ garbas ];
  };
}
