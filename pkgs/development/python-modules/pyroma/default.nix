{ lib, buildPythonPackage, fetchPypi
, docutils, pygments, setuptools, requests
}:

buildPythonPackage rec {
  pname = "pyroma";
  version = "3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+MGB4NXSkvEXka/Bj30CGKg8hc9k1vj7FXHOnSmiTko=";
  };

  propagatedBuildInputs = [ docutils pygments setuptools requests ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Test your project's packaging friendliness";
    homepage = "https://github.com/regebro/pyroma";
    license = licenses.mit;
  };
}
