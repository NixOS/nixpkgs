{ stdenv, fetchurl, getopt }:

let version = "2.3.1"; in

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "0asnlkzqms520r0dra08dzcz5hh6hs7lkajfw9wij3vrd0hxsnzz";
  };

  buildInputs = [ getopt ];

  patchPhase = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage    = "http://sourceforge.net/projects/libseccomp";
    license     = licenses.lgpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}
