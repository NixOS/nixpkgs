{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.53";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "802cd39468b4bf27ff23d9911f76a6c66689cc906e12b9102aeace6491a8d084";
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
