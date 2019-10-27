{ stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "184qncm2ss474prphw0xnf7ifkpgj955dzlb2vqq94z6xvf3xyd9";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with stdenv.lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
