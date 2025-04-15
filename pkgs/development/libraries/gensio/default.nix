{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.8.12";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DlveXTkdNu6Pb/0sL9K5HaOJ9HEhv2gwk5Kka9nI7U0=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ openssl ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    mainProgram = "gensiot";
    platforms = platforms.unix;
  };
}
