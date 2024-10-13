{ lib, stdenv, fetchurl, orc, pkg-config, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "schroedinger";
  version = "1.0.11";

  src = fetchurl {
    url = "https://download.videolan.org/contrib/${pname}-${version}.tar.gz";
    sha256 = "04prr667l4sn4zx256v1z36a0nnkxfdqyln48rbwlamr6l3jlmqy";
  };

  outputs = [ "out" "dev" "devdoc" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ orc ];

  doCheck = (!stdenv.hostPlatform.isDarwin);

  patchFlags = [ "-p0" ];
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/master/multimedia/schroedinger/files/patch-testsuite-Makefile.am.diff";
      sha256 = "0cc8ymvgjgwy7ghca2dd8m8pxpinf27s2i8krf2m3fzv2ckq09v3";
    })
  ];

  meta = with lib; {
    description = "Implementation of the Dirac video codec in ANSI C";
    homepage = "https://sourceforge.net/projects/schrodinger/";
    maintainers = [ ];
    license = [ licenses.mpl11 licenses.lgpl2 licenses.mit ];
    platforms = platforms.unix;
  };
}
