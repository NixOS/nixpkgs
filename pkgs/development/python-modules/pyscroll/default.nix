{ lib, buildPythonPackage, fetchPypi, pygame }:

buildPythonPackage rec {
  pname = "pyscroll";
  version = "2.19.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "175d39rymnx3v3mcfjjkr1wv76nsl1s00z04nzsspklyk0ih2783";
  };

  propagatedBuildInputs = [ pygame ];

  meta = with lib; {
    homepage = "https://github.com/bitcraft/pyscroll";
    description = "Python library for scrolling games with animated maps in pygame";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ geistesk ];
  };
}

