{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98a94b32d4929d3e34595b4654b8e7f951182f540056b9cb734c88899912f729";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
