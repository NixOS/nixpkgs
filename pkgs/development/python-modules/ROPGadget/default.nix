{ stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0idiicgpijar9l9kqmfdh865c2mkfgxg0q7lpz77jc09l6q0afjh";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with stdenv.lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
