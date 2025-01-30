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
    sha256 = "8495f57b3e03d8e46d5f1b2cc62ca881aca392fd5cc048dc0aa2e1a6d23ecdb6";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    description = "Heap with decrease-key and increase-key operations";
    homepage = "http://stutzbachenterprises.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
