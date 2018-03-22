{ fetchurl, stdenv, pkgconfig, gnome3, gtk3, atk, gobjectIntrospection
, spidermonkey_52, pango, readline, glib, libxml2, dbus, gdk_pixbuf
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gjs-${version}";
  version = "1.52.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1jm40imin4sxzfcxcbmf4v71apk8y9icccq1a4m4mlz1wm2s092m";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gjs"; attrPath = "gnome3.gjs"; };
  };

  outputs = [ "out" "installedTests" ];

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ libxml2 gobjectIntrospection gtk3 glib pango readline dbus ];

  propagatedBuildInputs = [ spidermonkey_52 ];

  configureFlags = [
    "--enable-installed-tests"
  ];

  postPatch = ''
    for f in installed-tests/*.test.in; do
      substituteInPlace "$f" --subst-var-by pkglibexecdir "$installedTests/libexec/gjs"
    done
  '';

  postInstall = ''
    sed 's|-lreadline|-L${readline.out}/lib -lreadline|g' -i $out/lib/libgjs.la

    moveToOutput "share/installed-tests" "$installedTests"
    moveToOutput "libexec/gjs/installed-tests" "$installedTests"

    wrapProgram "$installedTests/libexec/gjs/installed-tests/minijasmine" \
      --prefix GI_TYPELIB_PATH : "${stdenv.lib.makeSearchPath "lib/girepository-1.0" [ gtk3 atk pango.out gdk_pixbuf ]}:$installedTests/libexec/gjs/installed-tests"
  '';

  meta = with stdenv.lib; {
    description = "JavaScript bindings for GNOME";
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
