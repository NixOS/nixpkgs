{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.100";
  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CEYoP55w/Zq7RI1u8sbY9vjqDjT9jSIzDuoRIMmxlfY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # A few more dependencies I don't want to handle right now...
  doCheck = false;

  pythonImportsCheck = [
    "pex"
  ];

  meta = with lib; {
    description = "Python library and tool for generating .pex (Python EXecutable) files";
    homepage = "https://github.com/pantsbuild/pex";
    license = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };
}
