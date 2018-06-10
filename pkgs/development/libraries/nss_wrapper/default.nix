{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nss_wrapper-1.1.3";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "18rsaw8r8xwn5003arc7xw8iliwbmzxfxgacmp6lhsdwqla4rf69";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
