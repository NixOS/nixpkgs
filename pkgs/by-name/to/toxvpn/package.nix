{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nlohmann_json,
  libtoxcore,
  libsodium,
  libcap,
  zeromq,
  systemd,
}:

stdenv.mkDerivation {
  pname = "toxvpn";
  version = "0-unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "cleverca22";
    repo = "toxvpn";
    rev = "c727451eb871b43855b825ff93dc48fa0d3320b6";
    sha256 = "sha256-UncU0cpoyy9Z0TCChGmaHpyhW9ctz32gU7n3hgpOEwU=";
  };

  buildInputs = [
    libtoxcore
    nlohmann_json
    libsodium
    zeromq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    systemd
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [ "-DSYSTEMD=1" ];

  postInstall = "cp ${./bootstrap.json} $out/share/toxvpn/";

  installCheckPhase = "$out/bin/toxvpn -h";
  doInstallCheck = true;

  meta = with lib; {
    description = "Powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage = "https://github.com/cleverca22/toxvpn";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      cleverca22
      craigem
      obadz
      toonn
    ];
    platforms = platforms.unix;
  };
}
