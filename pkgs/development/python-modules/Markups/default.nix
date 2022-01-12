{ lib
, buildPythonPackage
, fetchPypi
, python-markdown-math
, markdown
, docutils
, pygments
, pyyaml
}:

buildPythonPackage rec {
  pname = "Markups";
  version = "3.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab9747a72c1c6457418eb4276c79871977c13a654618e4f12e2a1f0990fbf2fc";
  };

  checkInputs = [ markdown docutils pygments pyyaml ];
  propagatedBuildInputs = [ python-markdown-math ];

  meta = {
    description = "A wrapper around various text markup languages.";
    homepage = "https://github.com/retext-project/pymarkups";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ klntsky ];
  };
}
