{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e24ecb7e2cf0bf43fa9d4255d3ae2bd0b7ce30b1d1b89ace7aa68aca1152f37a";
  };

  meta = with stdenv.lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = https://github.com/txels/ddt;
    license = licenses.mit;
  };

}
