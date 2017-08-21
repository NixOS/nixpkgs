{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.6";
  pname = "python-stdnum";
  name = "${pname}-${version}";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/python-stdnum/${name}.tar.gz";
    sha256 = "157a0aef01b1e846ddd11252dc516637da6b3347e32f0130825b7fae1d8b4655";
  };
  meta = {
    homepage = http://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
