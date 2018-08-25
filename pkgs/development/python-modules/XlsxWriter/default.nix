{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1224b971c174f33b954f9a1906679d0049399bd6a5a8c78bbae2d6c2c4facebd";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
