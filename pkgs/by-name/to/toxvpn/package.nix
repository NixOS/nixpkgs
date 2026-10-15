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
  systemdLibs,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "toxvpn";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "cleverca22";
    repo = "toxvpn";
    rev = "300991571421d6bbcbc9786c8e7a479b7b24d82b";
    hash = "sha256-7kJ/vLJ+xYD2A4DaDGrW0NScByU/etINhPhZRRnS6Yw=";
  };

  buildInputs = [
    libtoxcore
    nlohmann_json
    libsodium
    zeromq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    systemdLibs
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [ "-DSYSTEMD=1" ];

  # https://nodes.tox.chat/json
  postInstall = "cp ${./bootstrap.json} $out/share/toxvpn/bootstrap.json";

  installCheckPhase = "$out/bin/toxvpn -h";
  doInstallCheck = true;

  passthru.tests.nixos = nixosTests.toxvpn;

  meta = {
    description = "Powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage = "https://github.com/cleverca22/toxvpn";
    license = lib.licenses.gpl3;
    mainProgram = "toxvpn";
    maintainers = with lib.maintainers; [
      cleverca22
      craigem
      obadz
      toonn
    ];
    platforms = lib.platforms.unix;
  };
}
