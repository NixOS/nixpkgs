{ stdenv, buildPythonPackage, isPy3k, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "Metaphone";
  version = "0.6";
  name  = "metaphone-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09ysaczwh2rlsqq9j5fz7m4pq2fs0axp5vvivrpfrdvclvffl2xd";
  };

  disabled = isPy3k;

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    homepage = https://github.com/oubiwann/metaphone;
    description = "A Python implementation of the metaphone and double metaphone algorithms";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
