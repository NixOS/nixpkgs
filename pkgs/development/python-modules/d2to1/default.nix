{ buildPythonPackage
, lib
, fetchPypi
, nose
}:
buildPythonPackage rec {
  pname = "d2to1";
  version = "0.2.11";

  checkInputs = [ nose ];

  src = fetchPypi {
    inherit version pname;
    sha256 = "1a5z367b7dpd6dgi0w8pymb68aj2pblk8w04l2c8hibhj8dpl2b4";
  };

  meta = with lib;{
    description = "Support for distutils2-like setup.cfg files as package metadata";
    homepage = https://github.com/embray/d2to1;
    license = licenses.bsd2;
    maintainers = with maintainers; [ makefu ];
  };
}
