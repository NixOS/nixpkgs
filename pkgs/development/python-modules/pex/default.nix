{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "pex";
  version = "2.1.55";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f6b60b9c50996ec3476e36dddff34afa98dc2d68fa73ed121d3c41232df1379";
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
