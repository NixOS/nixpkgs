{ stdenv, fetchurl, cmake, perl, zlib }:

stdenv.mkDerivation rec {
  pname = "libzip";
  version = "1.5.2";

  src = fetchurl {
    url = "https://www.nih.at/libzip/${pname}-${version}.tar.gz";
    sha256 = "05ay8cbm882br0ir2cmzrvdq8q5mr1bnf53l4305xzigpd54lsdy";
  };

  postPatch = ''
    patchShebangs man/handle_links
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake perl ];
  propagatedBuildInputs = [ zlib ];

  preCheck = ''
    # regress/runtests is a generated file
    patchShebangs regress
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
