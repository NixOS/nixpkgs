{ lib, stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51d7cbdf51ac8b3f3f00bc0d4ae44433ef58d3bf5495efb316ec918654f1e6c3";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
