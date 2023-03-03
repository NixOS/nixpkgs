{ lib, stdenv, fetchurl, perl, linuxPackages_latest }:

stdenv.mkDerivation rec {
  pname = "linux-manual";
  inherit (linuxPackages_latest.kernel) version src;

  nativeBuildInputs = [ perl ];

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    patchShebangs --build \
      scripts/kernel-doc \
      scripts/split-man.pl
  '';

  installPhase = ''
    mandir=$out/share/man/man9
    mkdir -p $mandir

    KBUILD_BUILD_TIMESTAMP=$(stat -c %Y Makefile) \
    grep -F -l -Z \
      --exclude-dir Documentation \
      --exclude-dir tools \
      -R '/**' \
      | xargs -0 -n 256 -P $NIX_BUILD_CORES \
        $SHELL -c '{ scripts/kernel-doc -man "$@" || :; } \
          | scripts/split-man.pl '$mandir kernel-doc

    test -f $mandir/kmalloc.9
  '';

  meta = with lib; {
    homepage = "https://kernel.org/";
    description = "Linux kernel API manual pages";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ mvs ];
  };
}
