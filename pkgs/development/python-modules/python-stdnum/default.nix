{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  name = "python-stdnum-${version}";
  version = "1.5";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/python-stdnum/${name}.tar.gz";
    sha256 = "0zkkpjy4gc161dkyxjmingjw48glljlqqrl4fh2k5idf0frkvzhh";
  };
  meta = {
    homepage = "http://arthurdejong.org/python-stdnum/";
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
