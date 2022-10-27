{ lib
, buildPythonPackage
, fetchPypi
, GitPython
}:

buildPythonPackage rec {
  pname = "git-sweep";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1csp0zd049d643d409rfivbswwzrayb4i6gkypp5mc27fb1z2afd";
  };

  propagatedBuildInputs = [ GitPython ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "gitsweep" ];

  meta = with lib; {
    description = "A command-line tool that helps you clean up Git branches";
    homepage = "https://github.com/arc90/git-sweep";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };

}
