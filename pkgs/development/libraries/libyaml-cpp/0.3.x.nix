{stdenv, fetchurl, cmake, boostHeaders}:

stdenv.mkDerivation {
  name = "libyaml-cpp-0.3.0";

  src = fetchurl {
    url = http://yaml-cpp.googlecode.com/files/yaml-cpp-0.3.0.tar.gz;
    sha256 = "10kv25zgq96ybxc6c19lzpax1xi5lpxrdqa9x52nffsql6skil1c";
  };

  buildInputs = [ cmake boostHeaders ];

  meta = {
    homepage = http://code.google.com/p/yaml-cpp/;
    description = "A YAML parser and emitter for C++";
    license = "MIT";
  };
}
