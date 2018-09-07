{ stdenv, fetchurl, glib, libxml2, pkgconfig, gnome3
, gnomeSupport ? true, sqlite, glib-networking, gobjectIntrospection
, valaSupport ? true, vala_0_40
, intltool, python3 }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libsoup";
  version = "2.62.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1dkrz1iwsswscayfmjxqv2q00b87snlq9nxdccn5vck0vbinylwy";
  };

  postPatch = ''
    patchShebangs libsoup/
  '' + stdenv.lib.optionalString valaSupport ''
     substituteInPlace libsoup/Makefile.in --replace "\$(DESTDIR)\$(vapidir)" "\$(DESTDIR)\$(girdir)/../vala/vapi"
  '';

  outputs = [ "out" "dev" ];

  buildInputs = [ python3 sqlite ];
  nativeBuildInputs = [ pkgconfig intltool gobjectIntrospection ]
    ++ stdenv.lib.optionals valaSupport [ vala_0_40 ];
  propagatedBuildInputs = [ glib libxml2 ];

  # glib-networking is a runtime dependency, not a compile-time dependency
  configureFlags = [
    "--disable-tls-check"
    "--enable-vala=${if valaSupport then "yes" else "no"}"
    "--with-gnome=${if gnomeSupport then "yes" else "no"}"
  ];

  doCheck = false; # fails with "no: command not found"

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
