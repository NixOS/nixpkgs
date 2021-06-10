{ lib, buildPythonPackage, fetchPypi, docutils, isPy27 }:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "3.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "07vl2p16fw0jayfcn424ixfc3cyhj8pnm89b83h70hm5as9ggi4j";
  };

  propagatedBuildInputs = [ docutils ];

  # project has no tests
  doCheck = true;

  pythonImportsCheck = [ "rstcheck" ];

  meta = with lib; {
    homepage = "https://github.com/myint/rstcheck";
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cemguresci ];
  };
}
