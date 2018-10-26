{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "percol";
  version = "0.0.8";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "169s5mhw1s60qbsd6pkf9bb2x6wfgx8hn8nw9d4qgc68qnnpp2cj";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/mooz/percol;
    description = "Adds flavor of interactive filtering to the traditional pipe concept of shell";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
