{ stdenv, requireFile, gmp4, ncurses, zlib, clang_33, makeWrapper }:

let
  name    = "cryptol-${version}-${rev}";
  version = "1.8.27";
  rev     = "1";
  lss-ver = "lss-0.2d";
  jss-ver = "jss-0.4";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.libc
      stdenv.gcc.gcc
      gmp4
      ncurses
      zlib
    ] + ":${stdenv.gcc.gcc}/lib64";

  cryptol-bin =
    if stdenv.system == "i686-linux"
    then requireFile {
      url    = "http://cryptol.net";
      name   = "${name}-i386-centos6-linux.tar.gz";
      sha256 = "131jkj3nh29rwwq5w5sfdf5jrb3c7ayjp4709v1zh84q4d6b35nf";
    }
    else requireFile {
      url    = "http://cryptol.net";
      name   = "${name}-x86_64-centos6-linux.tar.gz";
      sha256 = "1dmkns8s6r2d6pvh176w8k3891frik6hmcr2ibghk4l6qr6gwarx";
    };

  lss-bin =
    if stdenv.system == "i686-linux"
    then requireFile {
      url    = "http://cryptol.net";
      name   = "${lss-ver}-centos6-32.tar.gz";
      sha256 = "015ssw3v523wwzkma0qbpj3jnyzckab5q00ypdz0gr3kjcxn5rxg";
    }
    else requireFile {
      url    = "http://cryptol.net";
      name   = "${lss-ver}-centos6-64.tar.gz";
      sha256 = "1zjy4xi8v3m6g8ydm9q6dgzg5xn0xc3a4zsll5plbhngprgwxcxm";
    };

  jss-bin =
    if stdenv.system == "i686-linux"
    then requireFile {
      url    = "http://cryptol.net";
      name   = "${jss-ver}-centos5-32.tar.gz";
      sha256 = "1rlj14fbh9k3yvals8jsarczwl51fh6zjaic0pnhpc9s4p0pnjbr";
    }
    else requireFile {
      url    = "http://cryptol.net";
      name   = "${jss-ver}-centos5-64.tar.gz";
      sha256 = "0smarm2pi3jz4c8jas9gwcbghc6vc375vrwxbdj1mqx4awlhnz1n";
    };

in
stdenv.mkDerivation rec {
  inherit name version cryptol-bin jss-bin lss-bin;

  src = [ cryptol-bin lss-bin jss-bin ];
  buildInputs = [ makeWrapper ];

  unpackPhase = ''
    tar xf ${cryptol-bin}
    tar xf ${lss-bin}
    tar xf ${jss-bin}
  '';

  installPhase = ''
    mkdir -p $out/share $out/libexec

    # Move Cryptol
    mv cryptol-${version}/bin $out
    mv cryptol-${version}/lib $out
    mv cryptol-${version}/man $out/share
    rm -f $out/bin/cryptol-2

    # Move JSS
    # Create a wrapper for jss to keep the .jar out of the way
    mv ${jss-ver}/bin/jss $out/libexec
    mv ${jss-ver}/bin/galois.jar $out/libexec
    makeWrapper $out/libexec/jss $out/bin/jss --run "cd $out/libexec"
    mv ${jss-ver}/doc/jss.1 $out/share/man/man1

    # Move LSS
    mv ${lss-ver}/bin/lss $out/bin
    mv ${lss-ver}/sym-api $out/include

    # Create a convenient 'lss-clang' wrapper pointing to a valid Clang verison
    ln -s ${clang_33}/bin/clang $out/bin/lss-clang

    # Hack around lack of libtinfo in NixOS
    ln -s ${ncurses}/lib/libncursesw.so.5.9 $out/lib/libtinfo.so.5
    ln -s ${stdenv.gcc.libc}/lib/libpthread-2.19.so $out/lib/libpthread.so.0
  '';

  fixupPhase = ''
    for x in bin/cryptol bin/edif2verilog bin/copy-iverilog bin/symbolic_netlist bin/jaig bin/vvp-galois bin/lss libexec/jss; do
      patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "$out/lib:${libPath}" $out/$x
      patchelf --shrink-rpath $out/$x
    done
  '';

  phases = "unpackPhase installPhase fixupPhase";

  meta = {
    description = "Cryptol: The Language of Cryptography";
    homepage    = "https://cryptol.net";
    license     = stdenv.lib.licenses.unfree;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
