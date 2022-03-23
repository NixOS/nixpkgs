{ lib
, buildPythonPackage
, fetchPypi
, flit-core
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.72";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0hhnBkbgt4bSlqjvYKX2Mhty/T1vBGm91HhKmyvVzmA=";
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
