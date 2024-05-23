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
    sha256 = "1x1yp63lg3jxpg9igw8lh5rc51q353ifsa1bailb4qb51r54kh0d";
  };

  # tests require the extra download of github.com/pmaupin/static_pdfs
  doCheck = false;

  meta = with lib; {
    description = "pdfrw is a pure Python library that reads and writes PDFs.";
    homepage = "https://github.com/pmaupin/pdfrw";
    maintainers = with maintainers; [ teto ];
    license = licenses.mit;
  };
}
