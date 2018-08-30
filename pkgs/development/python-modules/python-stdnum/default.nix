{ lib, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.9";
  pname = "python-stdnum";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchPypi {
    inherit pname version;
    sha256 = "d587a520182f9d8aef7659cca429f4382881589c8883a0a55322b2f94970bdb3";
  };
  meta = {
    homepage = https://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
