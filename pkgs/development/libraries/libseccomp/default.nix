{ stdenv, fetchurl, getopt }:

let version = "2.3.0"; in

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "07chdgr87aayn6sjm94y6gisl4j6si1hr9cqhs09l9bqfnky6mnp";
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
