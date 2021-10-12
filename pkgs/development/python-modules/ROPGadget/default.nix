{ lib, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc61186e0114ec67ec7ce374df8fd2ddc2a7cba129a1242338e900a7483fba22";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
