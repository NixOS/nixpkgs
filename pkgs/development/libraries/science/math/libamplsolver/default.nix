{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libamplsolver";
  version = "20211109";

  src = fetchurl {
    url = "https://ampl.com/netlib/ampl/solvers.tgz";
    sha256 = "sha256-LVmScuIvxmZzywPSBl9T9YcUBJP7UFAa3eWs9r4q3JM=";
  };

  patches = [
    # Debian provides a patch to build a shared library
    (fetchpatch {
      url = "https://sources.debian.org/data/main/liba/libamplsolver/0~20190702-2/debian/patches/fix-makefile-shared-lib.patch";
      sha256 = "sha256-96qwj3fLugzbsfxguKMce13cUo7XGC4VUE7xKcJs42Y=";
    })
  ];

  installPhase = ''
    runHook preInstall
    pushd sys.`uname -m`.`uname -s`
    install -D -m 0644 *.h -t $out/include
    install -D -m 0644 *.so* -t $out/lib
    install -D -m 0644 *.a -t $out/lib
    popd
    runHook postInstall
  '';

  meta = with lib; {
    description = "A library of routines that help solvers work with AMPL";
    homepage = "https://ampl.com/netlib/ampl/";
    license = [ licenses.mit ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ aanderse ];
  };
}
