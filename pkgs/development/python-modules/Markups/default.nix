{ lib
, buildPythonPackage
, fetchPypi
, python-markdown-math
, markdown
, docutils
, pygments
}:

buildPythonPackage rec {
  pname = "Markups";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e309d79dde0935576ce1def6752f2127a12e2c2ea2ae8b0c69f99ff8bc12181d";
  };

  checkInputs = [ markdown docutils pygments ];
  propagatedBuildInputs = [ python-markdown-math ];

  meta = {
    description = "A wrapper around various text markup languages.";
    homepage = "https://github.com/retext-project/pymarkups";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
