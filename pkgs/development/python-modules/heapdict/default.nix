{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "HeapDict";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nhvxyjq6fp6zd7jzmk5x4fg6xhakqx9lhkp5yadzkqn0rlf7ja0";
  };

  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "a heap with decrease-key and increase-key operations.";
    homepage = http://stutzbachenterprises.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
