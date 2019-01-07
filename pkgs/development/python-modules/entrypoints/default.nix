{ lib
, buildPythonPackage
, fetchPypi
, configparser
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lc4si3xb7hza424414rdqdc3vng3kcrph8jbvjqb32spqddf3f7";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = lib.optional (!isPy3k) configparser;

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = https://github.com/takluyver/entrypoints;
    license = lib.licenses.mit;
  };
}
