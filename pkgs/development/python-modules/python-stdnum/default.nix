{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.13";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0q4128rjdgavywhzlm2gz2n5ybc9b9sxs81g50dvxf5q7z9q63qj";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = "https://arthurdejong.org/python-stdnum/";
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
