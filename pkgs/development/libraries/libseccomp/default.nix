{ stdenv, fetchFromGitHub, autoreconfHook, getopt }:

stdenv.mkDerivation rec {
  name    = "libseccomp-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "seccomp";
    repo = "libseccomp";
    rev = "v${version}";
    sha256 = "0vfd6hx92cp1jaqxxaj30r92bfm6fmamxi2yqxrl82mqism1lk84";
  };

  buildInputs = [ autoreconfHook getopt ];

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
