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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ea19458dfca6a4562044e701aa8698089a0c659fc535689ed260f89a04f8d39";
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
