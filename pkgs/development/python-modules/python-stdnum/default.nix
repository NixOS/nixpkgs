{ lib, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  version = "1.10";
  pname = "python-stdnum";
  # Failing tests and dependency issue on Py3k
  disabled = isPy3k;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0prs63q8zdgwr5cxc5a43zvsm66l0gf9jk19qdf85m6isnp5186a";
  };
  meta = {
    homepage = https://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
