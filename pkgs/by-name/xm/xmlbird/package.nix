{
  lib,
  gccStdenv,
  fetchurl,
  python3,
  pkg-config,
  vala,
  glib,
  gobject-introspection,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "xmlbird";
  version = "1.2.15";

  src = fetchurl {
    url = "https://birdfont.org/xmlbird-releases/libxmlbird-${finalAttrs.version}.tar.xz";
    hash = "sha256-8GX4ijF+AxaGGFlSxRPOAoUezRG6592jOrifz/mWTRM=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [ glib ];

  postPatch = ''
    substituteInPlace configure \
      --replace 'platform.dist()[0]' '"nix"'
    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = {
    description = "XML parser for Vala and C programs";
    homepage = "https://birdfont.org/xmlbird.php";
    license = lib.licenses.lgpl3;
    maintainers = [ ];
  };
})
