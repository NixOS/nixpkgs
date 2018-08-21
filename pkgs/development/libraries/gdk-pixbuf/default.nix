{ stdenv, fetchurl, fetchFromGitLab, fetchpatch, fixDarwinDylibNames, meson, ninja, pkgconfig, gettext, python3, libxml2, libxslt, docbook_xsl
, docbook_xml_dtd_43, gtk-doc, glib, libtiff, libjpeg, libpng, libX11, gnome3
, jasper, gobjectIntrospection, doCheck ? false, makeWrapper }:

let
  pname = "gdk-pixbuf";
  version = "2.36.12";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  # TODO: Change back once tests/bug753605-atsize.jpg is part of the dist tarball
  # src = fetchurl {
  #   url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
  #   sha256 = "0d534ysa6n9prd17wwzisq7mj6qkhwh8wcf8qgin1ar3hbs5ry7z";
  # };
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gdk-pixbuf";
    rev = version;
    sha256 = "18lwqg63vyap2m1mw049rnb8fm869429xbf7636a2n21gs3d3jwv";
  };

  patches = [
    # TODO: since 2.36.8 gdk-pixbuf gets configured to use mime-type sniffing,
    # which requires access to shared-mime-info files during runtime.
    # For now, we are patching the build script to avoid the dependency.
    ./no-mime-sniffing.patch

    # Fix installed tests with meson
    # https://bugzilla.gnome.org/show_bug.cgi?id=795527
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=371381;
      sha256 = "0nl1cixkjfa5kcfh0laz8h6hdsrpdkxqn7a1k35jrb6zwc9hbydn";
    })

    # Add missing test file bug753605-atsize.jpg
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gdk-pixbuf/commit/87f8f4bf01dfb9982c1ef991e4060a5e19fdb7a7.patch;
      sha256 = "1slzywwnrzfx3zjzdsxrvp4g2q4skmv50pdfmyccp41j7bfyb2j0";
    })

    # Move installed tests to a separate output
    ./installed-tests-path.patch
  ];

  outputs = [ "out" "dev" "man" "devdoc" "installedTests" ];

  setupHook = ./setup-hook.sh;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext python3 libxml2 libxslt docbook_xsl docbook_xml_dtd_43
    gtk-doc gobjectIntrospection makeWrapper
  ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

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
    # meson erroneously installs loaders with .dylib extension on Darwin.
    # Their @rpath has to be replaced before gdk-pixbuf-query-loaders looks at them.
    stdenv.lib.optionalString stdenv.isDarwin ''
      for f in $out/${passthru.moduleDir}/*.dylib; do
          install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
          mv $f ''${f%.dylib}.so
      done
    ''
    # All except one utility seem to be only useful during building.
    + ''
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

      # We need to install 'loaders.cache' in lib/gdk-pixbuf-2.0/2.10.0/
      $dev/bin/gdk-pixbuf-query-loaders --update-cache
    '';

  # The fixDarwinDylibNames hook doesn't patch binaries.
  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    for f in $out/bin/* $dev/bin/*; do
        install_name_tool -change @rpath/libgdk_pixbuf-2.0.0.dylib $out/lib/libgdk_pixbuf-2.0.0.dylib $f
    done
  '';

  # The tests take an excessive amount of time (> 1.5 hours) and memory (> 6 GB).
  inherit doCheck;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gdk_pixbuf";
    };

    # gdk_pixbuf_moduledir variable from gdk-pixbuf-2.0.pc
    moduleDir = "lib/gdk-pixbuf-2.0/2.10.0/loaders";
  };

  meta = with stdenv.lib; {
    description = "A library for image loading and manipulation";
    homepage = http://library.gnome.org/devel/gdk-pixbuf/;
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
