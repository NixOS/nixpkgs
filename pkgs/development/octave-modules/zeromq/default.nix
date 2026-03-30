{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  zeromq,
  pkg-config,
  autoreconfHook,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "zeromq";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-zeromq";
    tag = "release-${version}";
    sha256 = "sha256-2n/Cc4E/qYeN5Ku+Lmg/UCJhiYNbXkFIY8s4/SP2J+Y=";
  };

  preAutoreconf = ''
    cd src
  '';

  postAutoreconf = ''
    cd ..
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  propagatedBuildInputs = [
    zeromq
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/zeromq/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "ZeroMQ bindings for GNU Octave";
  };
}
