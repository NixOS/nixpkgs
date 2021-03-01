{ buildPythonPackage
, fetchPypi
, lib
, nose
, msgpack
, greenlet
, trollius
, pythonOlder
, isPyPy
, pytestrunner
}:

buildPythonPackage rec {
  pname = "pynvim";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bc6204d465de5888a0c5e3e783fe01988b032e22ae87875912280bef0e40f8f";
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
