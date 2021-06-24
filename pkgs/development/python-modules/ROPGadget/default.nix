{ lib, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c0e56f2ba0aef13b2c8ca286aad663525b92020b11bacd16791f5236247905c";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
