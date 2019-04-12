{ stdenv, fetchurl, getopt, makeWrapper, utillinux }:

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "0paj1szszpf8plykrd66jqg1x3kmqs395rbjskahld2bnplcfx1f";
  };

  outputs = [ "out" "lib" "dev" "man" ];

  buildInputs = [ getopt makeWrapper ];

  patchPhase = ''
    patchShebangs .
  '';

  checkInputs = [ utillinux ];
  doCheck = false; # dependency cycle

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  meta = with stdenv.lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage    = "https://github.com/seccomp/libseccomp";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    badPlatforms = platforms.riscv;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
