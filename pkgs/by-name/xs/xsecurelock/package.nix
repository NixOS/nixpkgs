{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libX11,
  libXcomposite,
  libXft,
  libXmu,
  libXrandr,
  libXext,
  libXScrnSaver,
  pam,
  apacheHttpd,
  pamtester,
  xscreensaver,
  coreutils,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsecurelock";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "xsecurelock";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OPasi5zmvmcWnVCj/dU2KprzNmar51zDElD23750yk4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXcomposite
    libXft
    libXmu
    libXrandr
    libXext
    libXScrnSaver
    pam
    apacheHttpd
    pamtester
  ];

  configureFlags = [
    "--with-pam-service-name=login"
    "--with-xscreensaver=${xscreensaver}/libexec/xscreensaver"
  ];

  preConfigure = ''
    cat > version.c <<'EOF'
      const char *const git_version = "${finalAttrs.version}";
    EOF
  '';

  postInstall = ''
    wrapProgram $out/libexec/xsecurelock/saver_blank --prefix PATH : ${coreutils}/bin
  '';

  meta = {
    description = "X11 screen lock utility with security in mind";
    homepage = "https://github.com/google/xsecurelock";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.unix;
    mainProgram = "xsecurelock";
  };
})
