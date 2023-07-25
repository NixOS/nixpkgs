{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, guile
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-fibers";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wingo";
    repo = "fibers";
    rev = "v${version}";
    hash = "sha256-jJKA5JEHsmqQ/IKb1aNmOtoVaGKNjcgTKyo5VCiJbXM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    guile
    texinfo
  ];

  autoreconfPhase = "./autogen.sh";

  meta = with lib; {
    homepage = "https://github.com/wingo/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
