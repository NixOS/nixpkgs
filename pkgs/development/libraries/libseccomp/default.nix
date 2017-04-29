{ stdenv, fetchurl, getopt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "3ddc8c037956c0a5ac19664ece4194743f59e1ccd4adde848f4f0dae7f77bca1";
  };

  buildInputs = [ getopt makeWrapper ];

  patchPhase = ''
    patchShebangs .
  '';

  postInstall = ''
    wrapProgram $out/bin/scmp_sys_resolver --prefix LD_LIBRARY_PATH ":" $out/lib
  '';

  meta = with stdenv.lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage    = "https://github.com/seccomp/libseccomp";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}

