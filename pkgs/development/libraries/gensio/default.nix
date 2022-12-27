{ autoreconfHook
, fetchFromGitHub
, lib
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K2A61OflKdVVzdV8qH5x/ggZKa4i8yvs5bdPoOwmm7A=";
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
