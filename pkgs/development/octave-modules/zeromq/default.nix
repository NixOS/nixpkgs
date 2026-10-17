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
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-zeromq";
    tag = "release-${version}";
    sha256 = "sha256-6mDjOYbh5bFagEM+7otiF1I9iOqPklf0y02+vjCLYIs=";
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
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "ZeroMQ bindings for GNU Octave";
  };
}
