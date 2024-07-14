{
  lib,
  buildPythonPackage,
  fetchPypi,
  zope-testrunner,
  six,
  chardet,
}:

buildPythonPackage rec {
  pname = "ghdiff";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E89qT6bXtxN+BzTGntIv8cp2EINQzoywPQEkrEWErZ4=";
  };

  nativeCheckInputs = [ zope-testrunner ];
  propagatedBuildInputs = [
    six
    chardet
  ];

  meta = with lib; {
    homepage = "https://github.com/kilink/ghdiff";
    license = licenses.mit;
    description = "Generate Github-style HTML for unified diffs";
    mainProgram = "ghdiff";
    maintainers = [ maintainers.mic92 ];
  };
}
