{ stdenv, fetchurl, getopt }:

let version = "2.2.3"; in

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "1vgc9xgdx6mc4fj21axlv2ym9ndnz06ylq3ps3f8210n3xksdq7y";
  };

  buildInputs = [ getopt ];

  patchPhase = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "high level library for the Linux Kernel seccomp filter";
    homepage    = "http://sourceforge.net/projects/libseccomp";
    license     = licenses.lgpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}
