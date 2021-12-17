{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-ndb";
  version = "0.6.5";

  src = fetchPypi {
    pname = "pyroute2.ndb";
    inherit version;
    sha256 = "sha256-pNMJWE6e9seEKvT4MrSPxTRKsiXnDjhLrtG3/iuU2fg=";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [ "pr2modules.ndb" ];

  meta = with lib; {
    description = "NDB module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
