{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pyyaml
, pygments
, markdown
}:

buildPythonPackage rec {
  pname = "pymdown-extensions";
  version = "6.0";

  src = fetchPypi {
    extension = "tar.gz";
    inherit pname version;
    sha256 = "1pclfrfvzbazpsikarnvzdbcx2a71wr2zp12rqd2jfx0nlvczw3c";
  };

  propagatedBuildInputs = [ markdown ];

  checkInputs = [ pytest pyyaml pygments ];

  meta = {
    description = "Extension pack for Python Markdown";
    homepage = https://github.com/facelessuser/pymdown-extensions/;
    # TODO: exceptions?
    license = lib.licenses.mit;
  };
}
