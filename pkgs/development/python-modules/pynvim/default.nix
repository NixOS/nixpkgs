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
    sha256 = "3a795378bde5e8092fbeb3a1a99be9c613d2685542f1db0e5c6fd467eed56dff";
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
