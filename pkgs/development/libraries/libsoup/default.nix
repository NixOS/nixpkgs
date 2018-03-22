{ stdenv, fetchurl, fetchpatch, glib, libxml2, pkgconfig, gnome3
, gnomeSupport ? true, libgnome-keyring3, sqlite, glib-networking, gobjectIntrospection
, valaSupport ? true, vala_0_38
, libintlOrEmpty
, intltool, python }:
let
  pname = "libsoup";
  version = "2.60.2";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "7263cfe18872e2e652c196f5667e514616d9c97c861dfca82a65a55f45f0da01";
  };

  prePatch = ''
    patchShebangs libsoup/
  '' + stdenv.lib.optionalString valaSupport
  ''
     substituteInPlace libsoup/Makefile.in --replace "\$(DESTDIR)\$(vapidir)" "\$(DESTDIR)\$(girdir)/../vala/vapi"
  '';

  patches = [
    # remove for >= 2.60.3
    (fetchpatch {
      name = "buffer-overflow.patch"; # https://bugzilla.gnome.org/show_bug.cgi?id=788037
      url = "https://git.gnome.org/browse/libsoup/patch/?id=b79689833ba";
      sha256 = "1azbk540mbm4c6ip54ixbg9d6w7nkls9y81fzm3csq9a5786r3d3";
    })
  ];

  outputs = [ "out" "dev" ];

  buildInputs = libintlOrEmpty ++ [ intltool python sqlite ]
    ++ stdenv.lib.optionals valaSupport [ vala_0_38 ];
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libxml2 gobjectIntrospection ]
    ++ stdenv.lib.optionals gnomeSupport [ libgnome-keyring3 ];

  # glib-networking is a runtime dependency, not a compile-time dependency
  configureFlags = "--disable-tls-check"
    + " --enable-vala=${if valaSupport then "yes" else "no"}"
    + stdenv.lib.optionalString (!gnomeSupport) " --without-gnome";

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  passthru = {
    propagatedUserEnvPackages = [ glib-networking.out ];
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "HTTP client/server library for GNOME";
    homepage = https://wiki.gnome.org/Projects/libsoup;
    license = stdenv.lib.licenses.gpl2;
    inherit (glib.meta) maintainers platforms;
  };
}
