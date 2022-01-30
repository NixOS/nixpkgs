{ lib
, fetchPypi
, buildPythonPackage
, networkx
, numpy }:

buildPythonPackage rec {
  pname = "python-louvain";
  version = "0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-t7ot9QAv0o0+54mklTK6rRH+ZI5PIRfPB5jnUgodpWs=";
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
