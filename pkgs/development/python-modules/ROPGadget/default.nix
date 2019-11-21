{ stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "5.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lggiqws4dzq6k6c20l515pmjajl19gymsxfggkv771dv5kr1gbs";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with stdenv.lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
