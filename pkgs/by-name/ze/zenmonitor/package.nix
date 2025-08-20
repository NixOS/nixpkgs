{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "zenmonitor";
  version = "unstable-2024-05-21";

  src = fetchFromGitea {
    domain = "git.exozy.me";
    owner = "a";
    repo = "zenmonitor3";
    rev = "a09f0b25d33967fd32f3831304be049b008cdabf";
    sha256 = "sha256-5N1Hhv2s0cv4Rujw4wFGHyIy7NyKAFThVvAo+xXqSyk=";
  };

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Monitoring software for AMD Zen-based CPUs";
    mainProgram = "zenmonitor";
    license = licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [
      alexbakker
      artturin
    ];
  };
}
