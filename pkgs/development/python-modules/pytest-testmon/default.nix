{ pkgs
, lib
, pythonPackages
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "0.9.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df00594e55f8f8f826e0e345dc23863ebac066eb749f8229c515a0373669c5bb";
  };

  buildInputs = with pythonPackages; [ pytest ];
  propagatedBuildInputs = with pythonPackages; [ coverage ];
  checkPhase = with pythonPackages; ''
    ${pytest}/bin/pytest test
    '';

  meta = with lib; {
    homepage = "https://github.com/tarpas/pytest-testmon/";
    description = "This is a py.test plug-in which automatically selects and re-executes only tests affected by recent changes";
    license = licenses.mit;
    maintainers = [ maintainers.dmvianna ];
  };
}

