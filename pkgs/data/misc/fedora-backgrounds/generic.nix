{
  lib,
  stdenvNoCC,
  coreutils,
  imagemagick,
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

  nativeBuildInputs = [
    imagemagick
  ];

  postPatch = ''
    for f in $(find . -name 'Makefile*'); do
      substituteInPlace $f \
        --replace-warn "usr/share" "share" \
        --replace-warn "/usr/bin/" "" \
        --replace-warn "/bin/" ""
    done

    for f in $(find . -name '*.xml'); do
      substituteInPlace $f \
        --replace-warn "/usr/share" "$out/share"
    done;
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
