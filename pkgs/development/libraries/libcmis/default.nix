{ stdenv, fetchurl, boost, libxml2, pkgconfig, curl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libcmis-${version}";
  version = "0.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/libcmis/${name}.tar.gz";
    sha256 = "1dprvk4fibylv24l7gr49gfqbkfgmxynvgssvdcycgpf7n8h4zm8";
  };

  patches = [ ./gcc5.patch ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ boost libxml2 curl ];
  configureFlags = [ "--without-man" "--with-boost=${boost.dev}" "--disable-werror" "--disable-tests" ];

  # Cppcheck cannot find all the include files (use --check-config for details)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "C++ client library for the CMIS interface";
    homepage = https://sourceforge.net/projects/libcmis/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
