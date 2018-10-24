{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15yhjbx1xwdbfkg0l1c1wgjayb55zgm8rywjymj655yaqiammm5r";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
