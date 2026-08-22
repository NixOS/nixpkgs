{
  stdenv,
  lib,
  fetchFromGitHub,
  systemdLibs,
  pkg-config,
  discount,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udp514-journal";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "eworm-de";
    repo = "udp514-journal";
    tag = finalAttrs.version;
    hash = "sha256-ufxxeW2G6C/DEzVgVVrQjUsI4tDvaqi5VrXZIr2Eh7Y=";
  };

  buildInputs = [
    systemdLibs
  ];
  nativeBuildInputs = [
    pkg-config
    discount
  ];

  # brute-force patching - remove /usr/ from install paths
  postPatch = ''
    substituteInPlace Makefile --replace-fail "$(DESTDIR)/usr/" "$(DESTDIR)/"
  '';

  makeFlags = [ "DESTDIR=$(out)" ];
  installTargets = [
    "install-bin"
    "install-doc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests.nixos = nixosTests.udp514-journal;

  meta = with lib; {
    description = "Forward syslog from network (udp/514) to journal";
    homepage = "https://github.com/eworm-de/udp514-journal";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ usovalx ];
  };
})
