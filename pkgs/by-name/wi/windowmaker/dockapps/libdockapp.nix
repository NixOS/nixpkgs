{ lib
, stdenv
, autoreconfHook
, dockapps-sources
, fontutil
, libX11
, libXext
, libXpm
, mkfontdir
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdockapp";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/libdockapp";

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libX11 libXext libXpm fontutil mkfontdir ];

  # There is a bug on --with-font
  configureFlags = [
    "--with-examples=no"
    "--with-font=no"
  ];

  meta = {
    description = "A library providing a framework for dockapps";
    homepage = "https://www.dockapps.net/libdockapp";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
