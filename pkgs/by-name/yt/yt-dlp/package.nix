{
  lib,
  python3Packages,
  fetchPypi,
  ffmpeg-headless,
  rtmpdump,
  atomicparsley,
  atomicparsleySupport ? true,
  ffmpegSupport ? true,
  rtmpSupport ? true,
  withAlias ? false, # Provides bin/youtube-dl for backcompat
  update-python-libraries,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "yt-dlp";
  # The websites yt-dlp deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2025.6.9";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "yt_dlp";
    hash = "sha256-dR9To7YTU1Ir+AX6MLvL0WZmEmU345cG6rT4w2jxEaw=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  # expose optional-dependencies, but provide all features
  dependencies = lib.flatten (lib.attrValues optional-dependencies);

  optional-dependencies = {
    default = with python3Packages; [
      brotli
      certifi
      mutagen
      pycryptodomex
      requests
      urllib3
      websockets
    ];
    curl-cffi = [
      (python3Packages.buildPythonPackage rec {
        pname = "curl-cffi";
        version = "0.11.3";
        src =
          {
            x86_64-linux = fetchurl {
              url = "https://github.com/lexiforest/curl_cffi/releases/download/v${version}/curl_cffi-${version}-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
              hash = "sha256-6DBlvIm2clpNcrr688vd31a7TwFLxjvnP4fxs5A/0K4=";
            };
            aarch64-linux = fetchurl {
              url = "https://github.com/lexiforest/curl_cffi/releases/download/v${version}/curl_cffi-${version}-cp39-abi3-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
              hash = "sha256-4DWSoS4ozEPYGAcTsmuPv/4IydJqzp2qKHpQBZDUKVs=";
            };
            x86_64-darwin = fetchurl {
              url = "https://github.com/lexiforest/curl_cffi/releases/download/v${version}/curl_cffi-${version}-cp39-abi3-macosx_10_9_x86_64.whl";
              hash = "sha256-+1vewabDcXq0lFv6lahNGSOa6Uy34dE4in5usvsuMO4=";
            };
            aarch64-darwin = fetchurl {
              url = "https://github.com/lexiforest/curl_cffi/releases/download/v${version}/curl_cffi-${version}-cp39-abi3-macosx_11_0_arm64.whl";
              hash = "sha256-C6M89UhqAY/6EIJNTZQfdse9kP4oDgHBTxVqLuDs+Nw=";
            };
          }
          ."${stdenv.hostPlatform.system}"
            or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");
        format = "wheel";
        buildInputs = [ stdenv.cc.cc.lib ];
        nativeBuildInputs = [
          stdenv.cc.cc.lib
          autoPatchelfHook
        ];
      })
    ];
    secretstorage = with python3Packages; [
      cffi
      secretstorage
    ];
  };

  pythonRelaxDeps = [ "websockets" ];

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath =
        [ ]
        ++ lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg-headless
        ++ lib.optional rtmpSupport rtmpdump;
    in
    lib.optionals (packagesToBinPath != [ ]) [
      ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"''
    ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  postInstall = lib.optionalString withAlias ''
    ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
  '';

  passthru.updateScript = [
    update-python-libraries
    (toString ./.)
  ];

  meta = with lib; {
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    changelog = "https://github.com/yt-dlp/yt-dlp/blob/HEAD/Changelog.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [
      SuperSandro2000
      donteatoreo
    ];
    mainProgram = "yt-dlp";
  };
}
