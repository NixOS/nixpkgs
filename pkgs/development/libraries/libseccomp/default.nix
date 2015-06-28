{ stdenv, fetchFromGitHub, autoreconfHook, getopt }:

stdenv.mkDerivation rec {
  name    = "libseccomp-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "seccomp";
    repo = "libseccomp";
    rev = "v${version}";
    sha256 = "153k3jflcgij19nxghmwlvqlngl84vkld514d31490c6sfkr5fy2";
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
