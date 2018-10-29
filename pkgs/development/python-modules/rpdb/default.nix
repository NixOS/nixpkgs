{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "rpdb";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rql1hq3lziwcql0h3dy05w074cn866p397ng9bv6qbz85ifw1bk";
  };

  meta = with stdenv.lib; {
    description = "pdb wrapper with remote access via tcp socket";
    homepage = https://github.com/tamentis/rpdb;
    license = licenses.bsd2;
  };

}
