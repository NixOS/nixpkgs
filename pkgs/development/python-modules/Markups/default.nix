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
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2954d53656d9ec84f2f6c077e91a1de534e05647f20d327757283bbb5a857770";
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
