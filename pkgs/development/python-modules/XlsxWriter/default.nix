{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "XlsxWriter";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd4661c04a68621cb2ebc07c38b8b2e98e30bf213a16e1cf3675b61e26ca9bf2";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
