{ lib, fetchFromGitHub, buildPythonPackage, docutils }:

buildPythonPackage rec {
  pname = "rstcheck";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "myint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4AhENuT+LtUMCi+aaI/rKa2gHti8sKGLdVGjdRithXI=";
  };

  pythonImportsCheck = [ "rstcheck" ];
  propagatedBuildInputs = [ docutils ];

  meta = with lib; {
    description = "Checks syntax of reStructuredText and code blocks nested within it";
    homepage = "https://github.com/myint/rstcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ staccato ];
  };
}
