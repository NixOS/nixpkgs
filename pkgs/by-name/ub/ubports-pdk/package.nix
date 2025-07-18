{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  bash,
  coreutils,
  dosfstools,
  makeWrapper,
  mtools,
  wget,
  which,
  xz,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ubports-pdk";
  version = "0-unstable-2025-06-23";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "ubports-pdk";
    rev = "f97daec1a96f9427b23e35c8cc12e7c21fe893fd";
    hash = "sha256-s9GC5TiIQSn5JGRy3TU5COdbcW9cDZZ8eQpflSffyOw=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    coreutils
    dosfstools
    mtools
    wget
    which
    xz
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -Dm755 ubuntu-touch-pdk $out/share/ubuntu-touch-pdk/ubuntu-touch-pdk
    cp -R scripts $out/share/ubuntu-touch-pdk/

    makeWrapper $out/share/ubuntu-touch-pdk/ubuntu-touch-pdk $out/bin/ubuntu-touch-pdk \
      --prefix PATH : ${lib.makeBinPath finalAttrs.finalPackage.buildInputs}

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Platform Development Kit for Ubuntu Touch";
    homepage = "https://github.com/ubports/ubports-pdk";
    license = lib.licenses.gpl3Only;
    mainProgram = "ubuntu-touch-pdk";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.unix;
    # setup wants to use brew to install extra prerequisites
    broken = stdenvNoCC.hostPlatform.isDarwin;
  };
})
