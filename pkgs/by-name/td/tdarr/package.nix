{
  config,
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  ffmpeg,
  handbrake,
  mkvtoolnix,
  ccextractor,
  gtk3,
  libayatana-appindicator,
  wayland,
  libxkbcommon,
  mesa,
  libxcb,
  leptonica,
  glib,
  gobject-introspection,
  libX11,
  libxcursor,
  libxfixes,
  tesseract4,
  libredirect,
}:
let
  version = "2.58.02";

  platform =
    {
      x86_64-linux = "linux_x64";
      aarch64-linux = "linux_arm64";
      x86_64-darwin = "darwin_x64";
      aarch64-darwin = "darwin_arm64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  hashes = {
    linux_x64 = {
      server = "sha256-+nxwSGAkA+BPf481N6KHW7s0iJzoGFPWp0XCbsVEwrI=";
      node = "sha256-+vD5oaoYh/bOCuk/Bxc8Fsm9UnFICownSKvg9i726nk=";
    };
    linux_arm64 = {
      server = "sha256-Z8UBt05UWmDDdPZoFtXJIzTK7qmU14Yr3I+sukaWpsM=";
      node = "sha256-JjeFcoWxhb9g10Xn2EZgNdEEoQonAeKMLhxT2YIlSls=";
    };
    darwin_x64 = {
      server = "sha256-qdLiNRsKNnYoHni8CRDIxzqa7KibRYwcsc6o4QLEN1M=";
      node = "sha256-fdGejGmW8dybTzk4u3LJq2fYjrF2mFEC2BKFPWy3udc=";
    };
    darwin_arm64 = {
      server = "sha256-bImM62q9SgEJj9oHAIaZLvd7jXXbl1K7W63IyA7OXlw=";
      node = "sha256-fjqv48pEEkyQFPMtJJ4IJ65PJDBN+Gf1oTwHuvjgJPg=";
    };
  };

  serverSrc = fetchzip {
    url = "https://storage.tdarr.io/versions/${version}/${platform}/Tdarr_Server.zip";
    sha256 = hashes.${platform}.server;
    stripRoot = false;
  };

  nodeSrc = fetchzip {
    url = "https://storage.tdarr.io/versions/${version}/${platform}/Tdarr_Node.zip";
    sha256 = hashes.${platform}.node;
    stripRoot = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tdarr";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    gtk3
    libayatana-appindicator
    wayland
    libxkbcommon
    libxcb
    mesa
    tesseract4
    leptonica
    glib
    gobject-introspection
    libX11
    libxcursor
    libxfixes
    libredirect
  ];

  preInstall = ''
    mkdir -p $out/{bin,share/tdarr/{server,node}}
  '';

  installPhase = ''
    runHook preInstall

    # Copy Server contents (files are at root of serverSrc)
    cp -r ${serverSrc}/* $out/share/tdarr/server/

    # Copy Node contents (files are at root of nodeSrc)
    cp -r ${nodeSrc}/* $out/share/tdarr/node/

    chmod +x $out/share/tdarr/server/Tdarr_Server
    chmod +x $out/share/tdarr/node/Tdarr_Node

    runHook postInstall
  '';

  postInstall = ''
    chmod -R +w $out/share/tdarr
    rm -rf $out/share/tdarr/{server,node}/assets/app/{ffmpeg,ccextractor}*

    for module in server node; do
      mkdir -p $out/share/tdarr/$module/assets/app/ffmpeg/${platform}
      ln -s ${ffmpeg}/bin/ffmpeg $out/share/tdarr/$module/assets/app/ffmpeg/${platform}/ffmpeg
      ln -s ${ffmpeg}/bin/ffprobe $out/share/tdarr/$module/assets/app/ffmpeg/${platform}/ffprobe

      mkdir -p $out/share/tdarr/$module/assets/app/ccextractor/${platform}
      ln -s ${ccextractor}/bin/ccextractor $out/share/tdarr/$module/assets/app/ccextractor/${platform}/ccextractor
    done

    makeWrapper $out/share/tdarr/server/Tdarr_Server $out/bin/tdarr-server \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          handbrake
          mkvtoolnix
          ccextractor
        ]
      } \
      --run "export rootDataPath=\''${rootDataPath:-/var/lib/tdarr/server}" \
      --run "mkdir -p \"\$rootDataPath\"/configs \"\$rootDataPath\"/logs" \
      --run "cd \"\$rootDataPath\"" \
      --set-default handbrakePath "${handbrake}/bin/HandBrakeCLI" \
      --set-default ffmpegPath "${ffmpeg}/bin/ffmpeg" \
      --set-default mkvpropeditPath "${mkvtoolnix}/bin/mkvpropedit" \
      --set-default ffprobePath "${ffmpeg}/bin/ffprobe" \
      --set-default ccextractorPath "${ccextractor}/bin/ccextractor"

    makeWrapper $out/share/tdarr/node/Tdarr_Node $out/bin/tdarr-node \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          handbrake
          mkvtoolnix
          ccextractor
        ]
      } \
      --run "export rootDataPath=\''${rootDataPath:-/var/lib/tdarr/node}" \
      --run "mkdir -p \"\$rootDataPath\"/configs \"\$rootDataPath\"/logs \"\$rootDataPath\"/assets/app/plugins" \
      --run "cd \"\$rootDataPath\"" \
      --set-default handbrakePath "${handbrake}/bin/HandBrakeCLI" \
      --set-default ffmpegPath "${ffmpeg}/bin/ffmpeg" \
      --set-default mkvpropeditPath "${mkvtoolnix}/bin/mkvpropedit" \
  '';

  # TODO: package nvtop for gpu monitoring

  meta = {
    description = "Distributed transcode automation using FFmpeg/HandBrake";
    homepage = "https://tdarr.io";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ mistyttm ];
  };
})
