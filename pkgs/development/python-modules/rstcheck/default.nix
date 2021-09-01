{ lib, fetchPypi, buildPythonPackage, docutils }:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92c4f79256a54270e0402ba16a2f92d0b3c15c8f4410cb9c57127067c215741f";
  };

  doCheck = false;

  pythonImportsCheck = [ "rstcheck" ];
  propagatedBuildInputs = [ docutils ];

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
  };
}
