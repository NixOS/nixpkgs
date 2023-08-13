{ lib, stdenv, fetchurl, glib, dbus, libgcrypt, pkg-config, intltool
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgnome-keyring";
  version = "2.32.0";

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "030gka96kzqg1r19b4xrmac89hf1xj1kr5p461yvbzfxh46qqf2n";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ glib dbus libgcrypt ];
  nativeBuildInputs = [ pkg-config intltool ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    pkgConfigModules = [ "gnome-keyring-1" ];
    inherit (glib.meta) platforms maintainers;
    homepage = "https://wiki.gnome.org/Projects/GnomeKeyring";
    license = with lib.licenses; [ gpl2 lgpl2 ];
  };
})
