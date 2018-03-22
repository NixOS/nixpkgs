{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.8.1";
  pname = "python-stdnum";
  name = "${pname}-${version}";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/python-stdnum/${name}.tar.gz";
    sha256 = "d7162fdb29337aebed65700cc7297016f6cd32cae4ad7aed8f7e7531f0217943";
  };
  meta = {
    homepage = http://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
