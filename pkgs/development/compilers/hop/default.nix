{ lib, stdenv, fetchurl, bigloo }:

# Compute the “release” version of bigloo (before the first dash, if any)
let bigloo-release =
  let inherit (lib) head splitString; in
  head (splitString "-" (builtins.parseDrvName bigloo.name).version)
; in

stdenv.mkDerivation rec {
  name = "hop-3.3.0";
  src = fetchurl {
    url = "ftp://ftp-sop.inria.fr/indes/fp/Hop/${name}.tar.gz";
    sha256 = "14gf9ihmw95zdnxsqhn5jymfivpfq5cg9v0y7yjd5i7c787dncp5";
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
