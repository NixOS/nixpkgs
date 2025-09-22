{
  lib,
  stdenv,
  fetchurl,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "wcslib";
  version = "8.4";

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    hash = "sha256-lguERCbRSotTze7XgliqkojN7ZmncywGZ8ZPpqUBJtw=";
  };

  nativeBuildInputs = [ flex ];

  enableParallelBuilding = true;

  outputs = [
    "out"
    "man"
  ];

  # DOCDIR is set to the path $out/share/doc/wcslib, and DOCLINK points
  # to the same location.
  # `$(LN_S) $(notdir $(DOCDIR)) $(DOCLINK)` effectively running:
  # `ln -s wcslib $out/share/doc/wcslib`
  # This produces a broken link because the target location already exists
  postInstall = ''
    rm $out/share/doc/wcslib/wcslib
  '';

  meta = {
    homepage = "https://www.atnf.csiro.au/people/mcalabre/WCS/";
    description = "World Coordinate System library for astronomy";
    longDescription = ''
      Library for world coordinate systems for spherical geometries
      and their conversion to image coordinate systems. This is the
      standard library for this purpose in astronomy.
    '';
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
}
