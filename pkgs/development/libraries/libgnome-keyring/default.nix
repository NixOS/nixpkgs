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

  strictDeps = true;
  propagatedBuildInputs = [ glib dbus libgcrypt ];
  nativeBuildInputs = [ pkg-config intltool ];

  configureFlags = [
    # not ideal to use -config scripts but it's not possible switch it to pkg-config
    # binaries in dev have a for build shebang
    "LIBGCRYPT_CONFIG=${lib.getExe' (lib.getDev libgcrypt) "libgcrypt-config"}"
  ];

  postPatch = ''
    # uses pkg-config in some places and uses the correct $PKG_CONFIG in some
    # it's an ancient library so it has very old configure scripts and m4
    substituteInPlace ./configure \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    pkgConfigModules = [ "gnome-keyring-1" ];
    inherit (glib.meta) platforms maintainers;
    homepage = "https://gitlab.gnome.org/Archive/libgnome-keyring";
    license = with lib.licenses; [ gpl2 lgpl2 ];
  };
})
