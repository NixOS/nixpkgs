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
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xlj54w9bnmq4vidk6r08hwa6az7drahi08w1qf4j9q45rs8mrbc";
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
    homepage = https://github.com/neovim/python-client;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ garbas ];
  };
}
