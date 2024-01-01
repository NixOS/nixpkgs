{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, python3
, freetype
, expat
, libxslt
, gettext
, docbook-xsl-nons
, fop
, withPdf ? false
, docbook_xml_dtd_45
, gperf
, dejavu_fonts
, meson
, ninja
, CoreFoundation
}:

stdenv.mkDerivation rec {
  pname = "fontconfig";
  version = "2.15.0";

  outputs = [ "bin" "dev" "lib" "out" ]; # $out contains all the config

  src = fetchurl {
    url = "https://www.freedesktop.org/software/fontconfig/release/${pname}-${version}.tar.xz";
    hash = "sha256-Y6BljQ4G4PqIYQZFK1jvBPIfWCAuoCqUw53g0zNdfA4=";
  };

  patches = [
    # TODO: wait until it is merged.
    # https://gitlab.freedesktop.org/fontconfig/fontconfig/-/merge_requests/304
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/fontconfig/fontconfig/-/merge_requests/304.patch";
      hash = "";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    docbook-xsl-nons
    docbook_xml_dtd_45
    gperf
    libxslt
    pkg-config
    python3
  ] ++ lib.optionals withPdf [
    fop
  ];

  buildInputs = [
    expat
  ] ++ lib.optional stdenv.isDarwin CoreFoundation;

  propagatedBuildInputs = [
    freetype
  ];

  mesonFlags = [
    # otherwise the fallback is in $out/
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    # just <1MB; this is what you get when loading config fails for some reason
    "-Ddefault-fonts-dirs=${dejavu_fonts.minimal}"
    (lib.mesonEnable "doc-pdf" withPdf)
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      conf.d/write-35-lang-normalize-conf.py \
      doc/edit-xml.py \
      doc/extract-man-list.py \
      doc/run-quiet.py \
      fc-case/fc-case.py \
      fc-lang/fc-lang.py
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    for o in $(getAllOutputNames); do
        mv "$DESTDIR''${!o}" "$(dirname "''${!o}")"
    done

    mv "$DESTDIR/etc" "$out"

    # Ensure we did not forget to install anything.
    rmdir --parents --ignore-fail-on-non-empty "$DESTDIR${builtins.storeDir}"
    ! test -e "$DESTDIR"

    cd "$out/etc/fonts"
    xsltproc --stringparam fontDirectories "${dejavu_fonts.minimal}" \
      --path $out/share/xml/fontconfig \
      ${./make-fonts-conf.xsl} $out/etc/fonts/fonts.conf \
      > fonts.conf.tmp
    mv fonts.conf.tmp $out/etc/fonts/fonts.conf
    # We don't keep section 3 of the manpages, as they are quite large and
    # probably not so useful.
    rm -r $bin/share/man/man3
  '';

  env = {
    # HACK: We want to install configuration files to $out/etc
    # but fontconfig should read them from /etc on a NixOS system.
    # With autotools, it was possible to override Make variables
    # at install time but Meson does not support this
    # so we need to convince it to install all files to a temporary
    # location using DESTDIR and then move it to proper one in postInstall.
    DESTDIR = "dest";
  };

  meta = with lib; {
    description = "A library for font customization and configuration";
    homepage = "http://fontconfig.org/";
    license = licenses.bsd2; # custom but very bsd-like
    platforms = platforms.all;
    maintainers = with maintainers; teams.freedesktop.members ++ [ ];
  };
}
