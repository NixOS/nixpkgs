{ autoreconfHook
, fetchFromGitHub
, lib
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tdMdIudB8zZWXF+Q0YhFo9Q4VHjLJh3rdfQsYhgo2DU=";
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
