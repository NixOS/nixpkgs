{ stdenv, fetchurl, getopt, makeWrapper }:

stdenv.mkDerivation rec {
  name = "libseccomp-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "0mdiyfljrkfl50q1m3ws8yfcyfjwf1zgkvcva8ffcwncji18zhkz";
  };

  outputs = [ "out" "lib" "dev" "man" ];

  buildInputs = [ getopt makeWrapper ];

  patchPhase = ''
    patchShebangs .
  '';

  # Hack to ensure that patchelf --shrink-rpath get rids of a $TMPDIR reference.
  preFixup = "rm -rfv src";

  meta = with stdenv.lib; {
    description = "High level library for the Linux Kernel seccomp filter";
    homepage    = "https://github.com/seccomp/libseccomp";
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    badPlatforms = platforms.riscv;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}
