{ lib
, fetchPypi
, buildPythonPackage
, networkx
, numpy }:

buildPythonPackage rec {
  pname = "python-louvain";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KoVu374plSpgpVOKhLt4zKGPaISoi5Ml6FoRyN1JF+s=";
  };

  propagatedBuildInputs = [ networkx numpy ];

  pythonImportsCheck = [ "community" ];

  meta = with lib; {
    homepage = "https://github.com/taynaud/python-louvain";
    description = "Louvain Community Detection";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
