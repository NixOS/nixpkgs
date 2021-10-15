{ autoreconfHook
, fetchFromGitHub
, lib
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eE+FZNgXievh1AKv2CLnF3Zo35CuwK0cm/Pfs1YdKO4=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
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
    platforms = platforms.unix;
  };
}
