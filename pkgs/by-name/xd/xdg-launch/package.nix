{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  libtool,
  perl,
  pkg-config,
  glib,
  libxrandr,
  libx11,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-launch";
  version = "1.12";

  postPatch = ''
    # fix gettext configuration
    echo 'AM_GNU_GETTEXT_VERSION' >> configure.ac
    echo 'AM_GNU_GETTEXT([external])' >> configure.ac

    sed -i data/*.desktop \
      -e "s,/usr/bin,/$out/bin,g"
  '';

  src = fetchFromGitHub {
    owner = "bbidulock";
    repo = "xdg-launch";
    rev = finalAttrs.version;
    sha256 = "sha256-S/0Wn1T5MSOPN6QXkzfmygHL6XTAnnMJr5Z3fBzsHEw=";
  };

  preConfigure = "./autogen.sh";

  buildInputs = [
    libx11
    libxrandr
    glib # can be optional
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
    perl # pod2man
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/bbidulock/xdg-launch";
    description = "Command line XDG compliant launcher and tools";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ck3d ];
  };
})
