{ autoreconfHook
, fetchFromGitHub
, lib
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lpP/pmM06zIw+9EZe+zywExLOcrN3K7IMK32XSrCmYs=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    mainProgram = "gensiot";
    platforms = platforms.unix;
  };
}
