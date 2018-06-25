{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.9";
  pname = "python-stdnum";
  name = "${pname}-${version}";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/python-stdnum/${name}.tar.gz";
    sha256 = "d587a520182f9d8aef7659cca429f4382881589c8883a0a55322b2f94970bdb3";
  };
  meta = {
    homepage = http://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
