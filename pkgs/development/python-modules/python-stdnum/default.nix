{ lib, fetchurl, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.7";
  pname = "python-stdnum";
  name = "${pname}-${version}";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchurl {
    url = "mirror://pypi/p/python-stdnum/${name}.tar.gz";
    sha256 = "987c25e1047e8742131bcf29dac7a406987adb1463465749e2daaba8cb19d264";
  };
  meta = {
    homepage = http://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
