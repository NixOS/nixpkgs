{
  lib,
  stdenv,
  fetchFromSourcehut,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "wlopm";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "wlopm";
    rev = "v${version}";
    sha256 = "sha256-kcUJVB5jP2qZ1YgJDEBsyn5AgwhRxQmzOrk0gKj1MeM=";
  };

  strictDeps = true;
  nativeBuildInputs = [ wayland-scanner ];
  buildInputs = [ wayland ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple client implementing zwlr-output-power-management-v1";
    homepage = "https://git.sr.ht/~leon_plickat/wlopm";
    mainProgram = "wlopm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arjan-s ];
    platforms = platforms.linux;
  };
}
