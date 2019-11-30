{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.12";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "19fb5asv0ngnbpiz1bqzq2jhgn845kv9hjcjajsgzgfp2k24f4sc";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = https://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
