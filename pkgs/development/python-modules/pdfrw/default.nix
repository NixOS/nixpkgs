{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pdfrw";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DcBJSg5lYbJoVCso7eIoA4fCcoEU8RfTu12OR4e5PvQ=";
  };

  # tests require the extra download of github.com/pmaupin/static_pdfs
  doCheck = false;

  meta = with lib; {
    description = "pdfrw is a pure Python library that reads and writes PDFs";
    homepage = "https://github.com/pmaupin/pdfrw";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
