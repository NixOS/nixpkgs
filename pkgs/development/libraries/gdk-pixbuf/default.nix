{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, python3, libxml2, libxslt, docbook_xsl
, docbook_xml_dtd_43, gtk-doc, glib, libtiff, libjpeg, libpng, libX11, gnome3
, jasper, shared-mime-info, libintl, gobjectIntrospection, doCheck ? false, makeWrapper }:

let
  pname = "gdk-pixbuf";
  version = "2.36.11";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1wz2vpciwdpdv612s8kbww08q80hgcs5dxrfsxp1a4q44n3snqmf";
  };

  outputs = [ "out" "dev" "man" "devdoc" ];

  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  # !!! We might want to factor out the gdk-pixbuf-xlib subpackage.
  buildInputs = [ libX11 libintl ] ++ stdenv.lib.optional (!stdenv.isDarwin) shared-mime-info;

  nativeBuildInputs = [
    meson ninja pkgconfig gettext python3 libxml2 libxslt docbook_xsl docbook_xml_dtd_43
    gtk-doc gobjectIntrospection makeWrapper
  ];

  propagatedBuildInputs = [ glib libtiff libjpeg libpng jasper ];

  mesonFlags = [
    # with_ & enable_will be removed in the future
    "-Dwith_docs=true"
    "-Denable_jasper=true"
    "-Dx11=true" # will be added in the future (default atm)
    "-Dwith_gir=${if gobjectIntrospection != null then "true" else "false"}"
  ];

  postPatch = ''
    chmod +x build-aux/* # patchShebangs only applies to executables
    patchShebangs build-aux
  '';

  postInstall =
    # All except one utility seem to be only useful during building.
    ''
      moveToOutput "bin" "$dev"
      moveToOutput "bin/gdk-pixbuf-thumbnailer" "$out"

      # We require runtime access to shared-mime-info
      ${stdenv.lib.optionalString (!stdenv.isDarwin) ''
      for f in $dev/bin/*; do
        wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      done
      wrapProgram $out/bin/gdk-pixbuf-thumbnailer --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      ''}

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
