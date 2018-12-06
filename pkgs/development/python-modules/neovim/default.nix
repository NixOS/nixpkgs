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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18x7gi1idsch11hijvy0mm2mk4f42rapz9niax4rnak14x2klqq2";
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
