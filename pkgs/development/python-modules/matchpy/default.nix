{ lib
, buildPythonPackage
, fetchPypi
, hopcroftkarp
, multiset
, pytest
, pytestrunner
, hypothesis
, setuptools_scm
, isPy27
}:

buildPythonPackage rec {
  pname = "matchpy";
  version = "0.4.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eefa1e50a10e1255db61bc2522a6768ad0701f8854859f293ebaa442286faadd";
  };

  buildInputs = [ setuptools_scm pytestrunner ];
  checkInputs = [ pytest hypothesis ];
  propagatedBuildInputs = [ hopcroftkarp multiset ];

  meta = with lib; {
    description = "A library for pattern matching on symbolic expressions";
    homepage = https://github.com/HPAC/matchpy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
