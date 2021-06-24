{
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  lib,
}:

buildPythonPackage rec {
  pname = "MeshLabXML";
  version = "2018.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1villmg46hqby5jjkkpxr5bxydr72y5b3cbfngwpyxxdljn091w8";
  };

  propagatedBuildInputs = [ ];

  doCheck = false; # Upstream not currently have any tests.

  pythonImportsCheck = [ "meshlabxml" ];

  meta = with lib; {
    homepage = "https://github.com/3DLIRIOUS/MeshLabXML";
    description = "Create and run MeshLab XML scripts with Python";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nh2 ];
  };
}
