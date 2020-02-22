{ stdenv, fetchurl, getopt, makeWrapper, utillinux }:

stdenv.mkDerivation rec {
  pname = "libseccomp";
  version = "2.4.2";

  src = fetchurl {
    url = "https://github.com/seccomp/libseccomp/releases/download/v${version}/libseccomp-${version}.tar.gz";
    sha256 = "0nsq81acrbkdr8zairxbwa33bj2a6126npp76b4srjl472sjfkxm";
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
    badPlatforms = [
      "alpha-linux"
      "riscv64-linux" "riscv32-linux"
      "sparc-linux" "sparc64-linux"
    ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
