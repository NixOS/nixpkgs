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
    sha256 = "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = lib.optional (!isPy3k) configparser;

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = "https://github.com/takluyver/entrypoints";
    license = lib.licenses.mit;
  };
}
