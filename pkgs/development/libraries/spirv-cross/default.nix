{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  name = "spirv-cross-${version}";
  version = "2019-04-26";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Cross";
    rev = "${version}";
    sha256 = "0vd5cib03qrxwbb82rrqvffz70b3w5ml7jf5nx63zj4b89hhl1rc";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Parse and convert SPIR-V to other shader languages";
    license = licenses.asl20;
  };
}
