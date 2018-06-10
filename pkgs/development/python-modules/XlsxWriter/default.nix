{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "XlsxWriter";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad947fd9e8edfb64f25e0ccfb161e109f279e5a5520b3dd22ddc03b7f8220887";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
