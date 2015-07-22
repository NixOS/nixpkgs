{ stdenv, fetchFromGitHub, autoreconfHook, getopt }:

stdenv.mkDerivation rec {
  name    = "libseccomp-${version}";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "seccomp";
    repo = "libseccomp";
    rev = "v${version}";
    sha256 = "0pl827qjls5b6kjj8qxxdwcn6rviqbm5xjqf0hgx6b04c836mswx";
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
