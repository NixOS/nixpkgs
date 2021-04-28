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
    sha256 = "0fcd9yh8j3r6xn4mclzwb73a12c0d6l1lw2f0ii4asnavxc9988y";
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
