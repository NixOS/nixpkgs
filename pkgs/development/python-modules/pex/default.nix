{ lib
, buildPythonPackage
, fetchPypi
, flit-core
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.63";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9aca96b7a6b60886195cfaf23f50bb2fee5ed3c83babf0b5ac249888e6fb6a80";
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
