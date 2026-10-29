{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pdfrw";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-DcBJSg5lYbJoVCso7eIoA4fCcoEU8RfTu12OR4e5PvQ=";
  };

  # tests require the extra download of github.com/pmaupin/static_pdfs
  doCheck = false;

  meta = {
    description = "Pure Python library that reads and writes PDFs";
    homepage = "https://github.com/pmaupin/pdfrw";
    maintainers = with lib.maintainers; [ teto ];
    license = lib.licenses.mit;
  };
})
