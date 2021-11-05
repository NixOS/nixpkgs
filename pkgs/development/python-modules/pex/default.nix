{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.54";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5878d97e4b6df920cb7b4a45254501746945193289c934c707e36107594c0982";
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
