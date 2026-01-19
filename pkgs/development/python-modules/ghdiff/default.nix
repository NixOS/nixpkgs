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
    sha256 = "17mdhi2sq9017nq8rkjhhc87djpi5z99xiil0xz17dyplr7nmkqk";
  };

  nativeCheckInputs = [ zope-testrunner ];
  propagatedBuildInputs = [
    six
    chardet
  ];

  meta = {
    homepage = "https://github.com/kilink/ghdiff";
    license = lib.licenses.mit;
    description = "Generate Github-style HTML for unified diffs";
    mainProgram = "ghdiff";
    maintainers = [ lib.maintainers.mic92 ];
  };
}
