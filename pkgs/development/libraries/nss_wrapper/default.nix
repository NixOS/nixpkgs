{ stdenv, fetchgit, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nss_wrapper-1.0.3";

  src = fetchgit {
    url = "git://git.samba.org/nss_wrapper.git";
    rev = "refs/tags/${name}";
    sha256 = "1jka6d873vhvfr7k378xvgxmbpka87w33iq6b91ynwg36pz53ifw";
  };

  buildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
