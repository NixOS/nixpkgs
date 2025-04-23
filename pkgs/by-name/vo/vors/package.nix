{
  curl,
  fetchurl,
  lib,
  genericUpdater,
  go,
  perl,
  stdenv,
  writeShellScript,
  zstd,
  pkg-config,
  opusfile,
  sox,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vors";
  version = "3.1.0";

  src = fetchurl {
    url = "http://www.vors.stargrave.org/download/vors-${finalAttrs.version}.tar.zst";
    hash = "sha256-ZRQI96j0n00eh1qxO8NgJeOQPU9bfzHoHa45xQNuzv8=";
  };

  buildInputs = [
    go
    opusfile
    sox
  ];

  nativeBuildInputs = [
    zstd
    pkg-config
    perl
    makeWrapper
  ];

  preConfigure = "export GOCACHE=$NIX_BUILD_TOP/gocache";

  buildPhase = ''
    runHook preBuild
    ./mk-non-static
    mkdir -p ./local/lib # Required to prevent building libopusfile
    ./build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/bin
    cp -f bin/* "$out"/bin
    chmod 755 "$out"/bin/*
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out"/bin/vors-client \
        --prefix PATH : ${lib.makeBinPath [ sox ]}
  '';

  enableParallelBuilding = true;

  passthru.updateScript = genericUpdater {
    versionLister = writeShellScript "vors-versionLister" ''
      ${curl}/bin/curl -s ${finalAttrs.meta.downloadPage} | ${perl}/bin/perl -lne 'print $1 if /td.*>([0-9.]+)</'
    '';
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Very simple and usable multi-user VoIP solution";
    downloadPage = "http://www.vors.stargrave.org/Install.html";
    homepage = "http://www.vors.stargrave.org/";
    license = lib.licenses.gpl3Only;
    longDescription = ''
      VoRS – Vo(IP) Really Simple. Very simple and usable multi-user
      VoIP solution. Some kind of alternative to Mumble without
      gaming-related features.

      Mumble has wonderful simplicity and workability, but its
      client is written on Qt, which requires hundreds of megabytes
      of additional libraries to build it up. And users tend to
      complain about its newer client versions quality and
      convenience.

      So let’s write as simple VoIP talking client as it is possible,
      without compromising convenience and simplicity for the user!
      I just want a simple command, which only requires to specify
      the server’s address with the key to just immediately talk
      with someone.

      No GUI requirement. Why would someone need a GUI for voice
      application? But a fancy real-time refreshing TUI would be
      desirable. Mumble tends to output no information, sometimes
      hiding the fact of a problem and that everything stopped
      working.

      Mono-cypher, mono-codec protocol.

      Maximal easiness of usage: here is your address, key, do me good.
    '';
    maintainers = with lib.maintainers; [
      dvn0
    ];
    platforms = lib.platforms.all;
  };
})
