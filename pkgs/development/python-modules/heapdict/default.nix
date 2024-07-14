{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "heapdict";
  version = "1.0.1";

  src = fetchPypi {
    pname = "HeapDict";
    inherit version;
    hash = "sha256-hJX1ez4D2ORtXxssxiyogayjkv1cwEjcCqLhptI+zbY=";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    description = "Heap with decrease-key and increase-key operations";
    homepage = "http://stutzbachenterprises.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
