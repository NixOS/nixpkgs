{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, python3, libxml2, libxslt, docbook_xsl
, docbook_xml_dtd_43, gtk-doc, glib, libtiff, libjpeg, libpng, libX11, gnome3
, jasper, gobjectIntrospection, doCheck ? false, makeWrapper }:

let
  pname = "gdk-pixbuf";
  version = "2.36.12";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0d534ysa6n9prd17wwzisq7mj6qkhwh8wcf8qgin1ar3hbs5ry7z";
  };

  patches = [
    # TODO: since 2.36.8 gdk-pixbuf gets configured to use mime-type sniffing,
    # which requires access to shared-mime-info files during runtime.
    # For now, we are patching the build script to avoid the dependency.
    ./no-mime-sniffing.patch

    # Move installed tests to a separate output
    # They are not usable at the moment, though:
    # https://bugzilla.gnome.org/show_bug.cgi?id=795527
    ./installed-tests-path.patch
  ];

  outputs = [ "out" "dev" "man" "devdoc" "installedTests" ];

  setupHook = ./setup-hook.sh;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext python3 libxml2 libxslt docbook_xsl docbook_xml_dtd_43
    gtk-doc gobjectIntrospection makeWrapper
  ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  mesonFlags = [
    "-Ddocs=true"
    "-Djasper=true"
    "-Dx11=true"
    "-Dgir=${if gobjectIntrospection != null then "true" else "false"}"
  ];

  postPatch = ''
    chmod +x build-aux/* # patchShebangs only applies to executables
    patchShebangs build-aux

    substituteInPlace tests/meson.build --subst-var-by installedtestsprefix "$installedTests"
  '';

  postInstall =
    # All except one utility seem to be only useful during building.
    ''
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit (doCheck);

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gdk_pixbuf";
    };
  };

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.unix;
  };
}
