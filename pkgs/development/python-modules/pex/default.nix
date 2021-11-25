{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.56";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dfb7ef551cc9d3d03a6e2dc1b1ba6183cd94f3cde7431836f017d60cc992d53";
  };

  nativeBuildInputs = [
    setuptools
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
