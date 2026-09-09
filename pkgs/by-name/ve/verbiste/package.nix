{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "verbiste";
  version = "0.1.49";

  src = fetchurl {
    url = "http://sarrazip.com/dev/verbiste-${finalAttrs.version}.tar.gz";
    hash = "sha256-SnVhM8DronsajiNtrlOuFzJWBbpIb+bLLrK+mWZoP6U=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxml2 ];

  configureFlags = [ "--without-gtk-app" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://sarrazip.com/dev/verbiste.html";
    description = "French and Italian verb conjugator";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
