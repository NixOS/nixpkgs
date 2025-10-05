{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  pkg-config,
  libcdio,
  libxml2,
  popt,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "vcdimager";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnu/vcdimager/${pname}-${version}.tar.gz";
    sha256 = "0ypnb1vp49nmzp5571ynlz6n1gh90f23w3z4x95hb7c2p7pmylb7";
  };

  patches = [
    # Fix build with libxml 2.14
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/vcdimager/-/raw/88dc511b7f3dea8fb45e0c2bfa1345a75a088848/libxml214.diff";
      hash = "sha256-gGD6gKsbR76zkQsT6RWo7zJpOQSbR8f0ZTyzwZ2oDJY=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxml2
    popt
    libiconv
  ];

  propagatedBuildInputs = [ libcdio ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/vcdimager/";
    description = "Full-featured mastering suite for authoring, disassembling and analyzing Video CDs and Super Video CDs";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
