{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "meshlabxml";
  version = "2018.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "MeshLabXML";
    inherit version;
    hash = "sha256-iIcErKStd3/5s26xsYoXJzffV8n9zill8QtDQ16lNO4=";
  };

  propagatedBuildInputs = [ ];

  doCheck = false; # Upstream not currently have any tests.

  pythonImportsCheck = [ "meshlabxml" ];

  meta = {
    homepage = "https://github.com/3DLIRIOUS/MeshLabXML";
    description = "Create and run MeshLab XML scripts with Python";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ nh2 ];
  };
}
