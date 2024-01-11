{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
 }:

buildPythonPackage rec {
  pname = "coolname";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bF1XMXWRBEeefKGVqbZPeQCsW+rUAYPAkyPH0L6edcc=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
  ];

  doCheck = true;

  pythonImportsCheck = [ "coolname" "coolname.data" ];

  meta = with lib; {
    changelog = "https://github.com/alexanderlukanin13/coolname/releases/tag/${version}";
    description = "Random Name and Slug Generator";
    homepage = "https://github.com/alexanderlukanin13/coolname";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nviets ];
  };
}
