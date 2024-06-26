{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  _name   = "liblockfile";
  version = "1.17";
  name    = "${_name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/libl/${_name}/${_name}_${version}.orig.tar.gz";
    sha256 = "sha256-bpN/NlCvq0qsGY80i4mxykLtzrF/trsJGPZCFDzP0V4=";
  };

  preConfigure = ''
    sed -i -e 's/ -g [^ ]* / /' Makefile.in
  '';

  preInstall = ''
    mkdir -p $out/{bin,lib,include,man} $out/man/man{1,3}
  '';

  meta = {
    description = "Shared library with NFS-safe locking functions";
    mainProgram = "dotlockfile";
    homepage = "http://packages.debian.org/unstable/libs/liblockfile1";
    license = lib.licenses.gpl2Plus;

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
  };
}
