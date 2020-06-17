{ stdenv, buildPythonPackage, fetchPypi
, capstone}:

buildPythonPackage rec {
  pname = "ROPGadget";
  version = "6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v34w88if3p4vn46aby24msfnxj6znmkf4848n4d24jnykxcsqk9";
  };

  propagatedBuildInputs = [ capstone ];

  meta = with stdenv.lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
