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

stdenv.mkDerivation rec {
  pname = "wmii";
  version = "unstable-2022-04-04";

  src = fetchFromGitHub {
    owner = "0intro";
    repo = "wmii";
    rev = "ff120c7fee6e1b3a30a4a800074394327fb1da9d";
    hash = "sha256-KEmWnobpT/5TdgT2HGPCpG1duz9Q6Z6PFSEBs2Ce+7g=";
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

  # Remove optional python2 functionality
  postInstall = ''
    rm -rf $out/lib/python* $out/etc/wmii-hg/python
  '';

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
