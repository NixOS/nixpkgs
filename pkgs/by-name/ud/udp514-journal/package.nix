{
  stdenv,
  lib,
  fetchFromGitHub,
  systemd,
  pkg-config,
  discount,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udp514-journal";
  version = "0.2.1-9-gfa88e98c9eb6";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = "udp514-journal";
    rev = finalAttrs.version;
    hash = "sha256-laaPrdvE9D3XeAIwYxPCS7OpIVcjSHS0RSEt0vFlfec=";
  };

  buildInputs = [
    systemd
    pkg-config
    discount
  ];

  # brute-force patching - remove /usr/ from install paths
  patchPhase = ''
    substituteInPlace Makefile --replace-fail "/usr/" "/"

    runHook postPatch
  '';

  installPhase = ''
    make install-bin install-doc DESTDIR="$out"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Forward syslog from network (udp/514) to journal";
    homepage = "https://github.com/eworm-de/udp514-journal";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ usovalx ];
  };
})
