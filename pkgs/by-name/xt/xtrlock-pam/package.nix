{
  lib,
  stdenv,
  fetchFromGitHub,
  python39,
  pkg-config,
  pam,
  xorg,
}:

stdenv.mkDerivation {
  pname = "xtrlock-pam";
  version = "3.4-post-20150909";

  src = fetchFromGitHub {
    owner = "aanatoly";
    repo = "xtrlock-pam";
    rev = "6f4920fcfff54791c0779057e9efacbbbbc05df6";
    sha256 = "sha256-TFfs418fpjBrAJNGW8U3jE0K7jQkfL4vCquAViKkXPw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    python39
    pam
    xorg.libX11
  ];

  configurePhase = ''
    substituteInPlace .config/options.py --replace /usr/include/security/pam_appl.h ${pam}/include/security/pam_appl.h
    substituteInPlace src/xtrlock.c --replace system-local-login xscreensaver
    python configure --prefix=$out
  '';

  meta = {
    homepage = "https://github.com/aanatoly/xtrlock-pam";
    description = "PAM based X11 screen locker";
    license = "unknown";
    maintainers = with lib.maintainers; [ ondt ];
    platforms = with lib.platforms; linux;
  };
}
