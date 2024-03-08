{ lib, stdenv, fetchurl, bigloo }:

# Compute the “release” version of bigloo (before the first dash, if any)
let bigloo-release =
  let inherit (lib) head splitString; in
  head (splitString "-" (builtins.parseDrvName bigloo.name).version)
; in

stdenv.mkDerivation rec {
  pname = "hop";
  version = "3.4.4";
  src = fetchurl {
    url = "ftp://ftp-sop.inria.fr/indes/fp/Hop/hop-${version}.tar.gz";
    sha256 = "sha256-GzXh4HC+SFFoUi7SMqu36iYRPAJ6tMnOHd+he6n9k1I=";
  };

  postPatch = ''
    substituteInPlace configure --replace "(os-tmp)" '(getenv "TMPDIR")'
  '';

  buildInputs = [ bigloo ];

  configureFlags = [
    "--bigloo=${bigloo}/bin/bigloo"
    "--bigloolibdir=${bigloo}/lib/bigloo/${bigloo-release}/"
  ];

  meta = with lib; {
    description = "A multi-tier programming language for the Web 2.0 and the so-called diffuse Web";
    homepage = "http://hop.inria.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
