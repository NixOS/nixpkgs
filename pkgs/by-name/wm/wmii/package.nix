{
  lib,
  stdenv,
  fetchFromGitHub,
  dash,
  libX11,
  libXext,
  libXft,
  libXinerama,
  libXrandr,
  libXrender,
  libixp,
  pkg-config,
  txt2tags,
  unzip,
  which,
}:

stdenv.mkDerivation {
  pname = "wmii";
  version = "0-unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "0intro";
    repo = "wmii";
    rev = "26848c93457606b350f57d6d313112a745a0cf3d";
    hash = "sha256-5l2aYAoThbA0Aq8M2vPTzaocQO1AvrnWqgXhmBLADVk=";
  };

  # for dlopen-ing
  postPatch = ''
    substituteInPlace lib/libstuff/x11/xft.c --replace "libXft.so" "$(pkg-config --variable=libdir xft)/libXft.so.2"
    substituteInPlace cmd/wmii.sh.sh --replace "\$(which which)" "${which}/bin/which"
  '';

  postConfigure = ''
    for file in $(grep -lr '#!.*sh'); do
      sed -i 's|#!.*sh|#!${dash}/bin/dash|' $file
    done

    cat <<EOF >> config.mk
    PREFIX = $out
    LIBIXP = ${libixp}/lib/libixp.a
    BINSH = ${dash}/bin/dash
    EOF
  '';

  patches = [
    # the python alternative wmiirc was not building due to errors with pyxp
    # this patch disables building it altogether
    ./001-disable-python2-build.patch
  ];

  nativeBuildInputs = [
    pkg-config
    unzip
  ];
  buildInputs = [
    dash
    libX11
    libXext
    libXft
    libXinerama
    libXrandr
    libXrender
    libixp
    txt2tags
    which
  ];

  meta = {
    homepage = "https://github.com/0intro/wmii";
    description = "Small, scriptable window manager, with a 9P filesystem interface and an acme-like layout";
    maintainers = with lib.maintainers; [ kovirobi ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux;
  };
}
