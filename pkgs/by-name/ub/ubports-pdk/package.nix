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
  version = "0-unstable-2026-11-04";

  src = fetchFromGitHub {
    owner = "ubports";
    repo = "ubports-pdk";
    rev = "79dbd66f3cbe4c37c0227d12766f0d130fb0fe49";
    hash = "sha256-AfLf8cAbKjfU5UFS8ZkyR704d9K9hA/FltBQim/GEjE=";
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
