{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "gitlab";
  version = "1.0.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "28425cd714fd1e4bc6b275acade5367bea869be85ac23ca5bd984375e742d172";
  };
  propagatedBuildInputs = [ requests ];
  
  meta = with lib; {
    description = "GitLab user Details";
    homepage = "https://yoginth.ml";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
