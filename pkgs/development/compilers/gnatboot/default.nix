{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gentoo-gnatboot-4.1";

  src = if stdenv.system == "i686-linux" then
    fetchurl {
      url = "mirror://gentoo/distfiles/gnatboot-4.1-i386.tar.bz2";
      sha256 = "0665zk71598204bf521vw68i5y6ccqarq9fcxsqp7ccgycb4lysr";
    }
    else if stdenv.system == "x86_64-linux" then
    fetchurl {
      url = "mirror://gentoo/distfiles/gnatboot-4.1-amd64.tar.bz2";
      sha256 = "1li4d52lmbnfs6llcshlbqyik2q2q4bvpir0f7n38nagp0h6j0d4";
    } else throw "Platform not supported";

  dontStrip=1;

  installPhase = ''
    mkdir -p $out
    cp -R * $out
    set +e
    for a in $out/bin/* ; do
      patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath $(cat $NIX_CC/nix-support/orig-libc)/lib:$(cat $NIX_CC/nix-support/orig-gcc)/lib64:$(cat $NIX_CC/nix-support/orig-gcc)/lib $a
    done
    set -e
    mv $out/bin/gnatgcc_2wrap $out/bin/gnatgcc
    ln -s $out/bin/gnatgcc $out/bin/gcc
  '';

  passthru = {
    langC = true; /* TRICK for gcc-wrapper to wrap it */
    langCC = false;
    langFortran = false;
    langAda = true;
  };

  meta = {
    homepage = http://gentoo.org;
    license = stdenv.lib.licenses.gpl3Plus;  # runtime support libraries are typically LGPLv3+
    maintainers = [
      stdenv.lib.maintainers.viric
    ];
    
    platforms = stdenv.lib.platforms.linux;
  };
}
