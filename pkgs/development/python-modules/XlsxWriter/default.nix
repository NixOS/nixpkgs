{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de9ef46088489915eaaee00c7088cff93cf613e9990b46b933c98eb46f21b47f";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
