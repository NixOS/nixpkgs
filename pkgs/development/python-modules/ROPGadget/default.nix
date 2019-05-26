{ stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19wly4x3mq73c91pplqjk0c7sx6710887czh514qk5l7j0ky6dxg";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with stdenv.lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
