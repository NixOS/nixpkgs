{ stdenv, fetchFromGitHub, opensp, pkgconfig, libxml2, curl
, autoconf, automake, libtool, gengetopt, libiconv }:

stdenv.mkDerivation rec {
  pname = "libofx";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "LibOFX";
    repo = pname;
    rev = version;
    sha256 = "1jx56ma351p8af8dvavygjwf6ipa7qbgq7bpdsymwj27apdnixfy";
  };

  preConfigure = "./autogen.sh";
  configureFlags = [ "--with-opensp-includes=${opensp}/include/OpenSP" ];
  nativeBuildInputs = [ pkgconfig libtool autoconf automake gengetopt ];
  buildInputs = [ opensp libxml2 curl ] ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  meta = { 
    description = "Opensource implementation of the Open Financial eXchange specification";
    homepage = http://libofx.sourceforge.net/;
    license = "LGPL";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ ];
  };
}
