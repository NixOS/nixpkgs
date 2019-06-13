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
  pname = "pynvim";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01dybk4vs452pljn1q3il5z2sd313ki0lgiglc0xmjc6wp290r6g";
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
