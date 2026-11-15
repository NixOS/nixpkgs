{
  lib,
  stdenvNoCC,
  coreutils,
}:

{
  version,
  src,
  patches ? [ ],
}:

stdenvNoCC.mkDerivation {
  inherit patches src version;

  pname = "fedora${lib.versions.major version}-backgrounds";

  dontBuild = true;

  postPatch = ''
    for f in ${
      if lib.versionOlder version "42" then "default/Makefile extras/Makefile" else "Makefile"
    }; do
      substituteInPlace $f \
        --replace-fail "usr/share" "share" \
        --replace-fail "/usr/bin/" "" \
        --replace-fail "/bin/" ""
    done

    ${lib.optionalString (lib.versions.major version == "42") ''
      substituteInPlace default/Makefile \
        --replace-fail '$(MAGICK) $(OUTNAME) -alpha off $@' '$(CP) $(OUTNAME) $@'
    ''}

    for f in $(find . -name '*.xml'); do
      substituteInPlace $f \
        --replace-fail "/usr/share" "$out/share"
    done
  '';

  installFlags = [
    "DESTDIR=$(out)"

    # The Xfce background directory is assumed to be in installed in an
    # FHS-compliant system. This is only effective for v36.0.0 and later
    # versions where the following variable is used.
    "WP_DIR_LN=$(DESTDIR)/share/backgrounds/$(WP_NAME)"
  ];

  meta = {
    homepage = "https://github.com/fedoradesign/backgrounds";
    description = "Set of default and supplemental wallpapers for Fedora";
    license = lib.licenses.cc-by-sa-40;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
