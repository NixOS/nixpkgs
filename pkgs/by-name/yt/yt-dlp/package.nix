{
  lib,
  python3Packages,
  atomicparsley,
  deno,
  fetchFromGitHub,
  ffmpeg-headless,
  installShellFiles,
  pandoc,
  rtmpdump,
  atomicparsleySupport ? true,
  ffmpegSupport ? true,
  javascriptSupport ? true,
  rtmpSupport ? true,
  withAlias ? false, # Provides bin/youtube-dl for backcompat
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "yt-dlp";
  # The websites yt-dlp deals with are a very moving target. That means that
  # downloads break constantly. Because of that, updates should always be backported
  # to the latest stable release.
  version = "2025.11.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "yt-dlp";
    tag = version;
    hash = "sha256-Em8FLcCizSfvucg+KPuJyhFZ5MJ8STTjSpqaTD5xeKI=";
  };

  postPatch = ''
    substituteInPlace yt_dlp/version.py \
      --replace-fail "UPDATE_HINT = None" 'UPDATE_HINT = "Nixpkgs/NixOS likely already contain an updated version.\n       To get it run nix-channel --update or nix flake update in your config directory."'
    # Until yt-dlp supports curl-cffi 0.14.x, this patch is needed:
    substituteInPlace yt_dlp/networking/_curlcffi.py \
      --replace-fail "if curl_cffi_version != (0, 5, 10) and not (0, 10) <= curl_cffi_version < (0, 14)" \
      "if curl_cffi_version != (0, 5, 10) and not (0, 10) <= curl_cffi_version"
  '';

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  # expose optional-dependencies, but provide all features
  dependencies = lib.concatAttrValues optional-dependencies;

  optional-dependencies = {
    default = with python3Packages; [
      brotli
      certifi
      mutagen
      pycryptodomex
      requests
      urllib3
      websockets
      yt-dlp-ejs # keep pinned version in sync!
    ];
    curl-cffi = [ python3Packages.curl-cffi ];
    secretstorage = with python3Packages; [
      cffi
      secretstorage
    ];
  };

  pythonRelaxDeps = [ "websockets" ];

  preBuild = ''
    python devscripts/make_lazy_extractors.py
  '';

  postBuild = ''
    python devscripts/prepare_manpage.py yt-dlp.1.temp.md
    pandoc -s -f markdown-smart -t man yt-dlp.1.temp.md -o yt-dlp.1
    rm yt-dlp.1.temp.md

    mkdir -p completions/{bash,fish,zsh}
    python devscripts/bash-completion.py completions/bash/yt-dlp
    python devscripts/zsh-completion.py completions/zsh/_yt-dlp
    python devscripts/fish-completion.py completions/fish/yt-dlp.fish
  '';

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - deno: required for full YouTube support (since 2025.11.12)
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath =
        lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg-headless
        ++ lib.optional javascriptSupport deno
        ++ lib.optional rtmpSupport rtmpdump;
    in
    lib.optionals (packagesToBinPath != [ ]) [
      ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"''
    ];

  checkPhase = ''
    # Check for "unsupported" string in yt-dlp -v output.
    output=$($out/bin/yt-dlp -v 2>&1 || true)
    if echo $output | grep -q "unsupported"; then
      echo "ERROR: Found \"unsupported\" string in yt-dlp -v output."
      exit 1
    fi
  '';

  postInstall = ''
    installManPage yt-dlp.1

    installShellCompletion \
      --bash completions/bash/yt-dlp \
      --fish completions/fish/yt-dlp.fish \
      --zsh completions/zsh/_yt-dlp

    install -Dm644 Changelog.md README.md -t "$out/share/doc/yt_dlp"
  ''
  + lib.optionalString withAlias ''
    ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/yt-dlp/yt-dlp/blob/${version}/Changelog.md";
    description = "Feature-rich command-line audio/video downloader";
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    license = lib.licenses.unlicense;
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    mainProgram = "yt-dlp";
    maintainers = with lib.maintainers; [
      SuperSandro2000
      FlameFlag
    ];
  };
}
