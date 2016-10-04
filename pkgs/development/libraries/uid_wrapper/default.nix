{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "uid_wrapper-1.2.0";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "0sfznk53kmz9m3rxwbv4pwwqs4bw3kr917y4n53h5jaxjym0m4c0";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
