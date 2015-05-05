{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nss_wrapper-1.0.3";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "0bysdijvi9n0jk74iklbfhbp0kvv81a727lcfd5q03q2hkzjfm18";
  };

  buildInputs = [ cmake pkgconfig (stdenv.cc.libc.out or null) ];
  # outputs TODO: missing glibc.out might become a general problem

  meta = with stdenv.lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
