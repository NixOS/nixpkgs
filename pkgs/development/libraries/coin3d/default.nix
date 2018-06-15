{ fetchurl, stdenv, libGLU_combined }:

stdenv.mkDerivation rec {
  name = "coin3d-${version}";
  version = "3.1.3";

  src = fetchurl {
    url = "https://bitbucket.org/Coin3D/coin/downloads/Coin-${version}.tar.gz";
    sha256 = "05ylhrcglm81dajbk132l1w892634z2i97x10fm64y1ih72phd2q";
  };

  patches = [
    (fetchurl {
      url = http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/media-libs/coin/files/coin-3.1.3-gcc-4.7.patch;
      name = "gcc-4.7.patch";
      sha256 = "076dyc52swk8qc7ylps53fg6iqmd52x8s7m18i80x49dd109yw20";
    })
    ./gcc-4.8.patch # taken from FC-17 source rpm
    # see https://bitbucket.org/Coin3D/coin/issues/128/crash-in-cc_memalloc_deallocate
    # patch adapted from https://bitbucket.org/Coin3D/coin/pull-requests/75/added-fix-for-issue-128-provided-by-fedora/diff
    ./sbhashentry.patch
  ];

  buildInputs = [ libGLU_combined ];

  meta = {
    homepage = http://www.coin3d.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
