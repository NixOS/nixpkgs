{ lib
, buildPythonPackage
, fetchPypi
, pyroute2-core
}:

buildPythonPackage rec {
  pname = "pyroute2-protocols";
  version = "0.6.1";

  src = fetchPypi {
    pname = "pyroute2.protocols";
    inherit version;
    sha256 = "16c22ygyxdn1mhnd2f34q9b2mqa27klk6di91w27ycb3aczmadlm";
  };

  propagatedBuildInputs = [
    pyroute2-core
  ];

  # pyroute2 sub-modules have no tests
  doCheck = false;

  pythonImportsCheck = [
    "pr2modules.protocols"
  ];

  meta = with lib; {
    description = "Protocols module for pyroute2";
    homepage = "https://github.com/svinota/pyroute2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.unix;
  };
}
