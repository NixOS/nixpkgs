{
  fetchurl,
  glib,
  gobject-introspection,
  lib,
  pkg-config,
  python3,
  stdenv,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmlbird";
  version = "1.2.15";

  src = fetchurl {
    url = "https://birdfont.org/xmlbird-releases/libxmlbird-${finalAttrs.version}.tar.xz";
    hash = "sha256-8GX4ijF+AxaGGFlSxRPOAoUezRG6592jOrifz/mWTRM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    python3
    vala
  ];

  buildInputs = [ glib ];

  postPatch = ''
    substituteInPlace configure \
      --replace-fail 'platform.version()' '"Nix"'
    patchShebangs .
  '';

  configureFlags = [ "--cc=${stdenv.cc.targetPrefix}cc" ];

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = {
    description = "XML parser for Vala and C programs";
    homepage = "https://birdfont.org/xmlbird.php";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ drawbu ];
  };
})
