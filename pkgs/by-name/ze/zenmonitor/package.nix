{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "zenmonitor";
  version = "unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "detiam";
    repo = "zenmonitor3";
    rev = "1e1ceec7353dc418578fe8ae56536bfee6adeca3";
    sha256 = "sha256-q5BeLu0A2XJkJL8ptN4hj/iLhQmpb16QEhOuIhNzVaI=";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Monitoring software for AMD Zen-based CPUs";
    homepage = "https://github.com/detiam/zenmonitor3";
    mainProgram = "zenmonitor";
    license = lib.licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      alexbakker
      artturin
    ];
  };
}
