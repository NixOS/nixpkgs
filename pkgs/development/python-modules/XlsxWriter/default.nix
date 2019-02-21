{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07e38c73b687e2f867151adce821e43e02856c4d8c6e482807b6ea7f4ac9506c";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
