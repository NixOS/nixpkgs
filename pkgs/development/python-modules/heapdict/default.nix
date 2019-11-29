{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "HeapDict";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8495f57b3e03d8e46d5f1b2cc62ca881aca392fd5cc048dc0aa2e1a6d23ecdb6";
  };

  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "a heap with decrease-key and increase-key operations.";
    homepage = http://stutzbachenterprises.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
