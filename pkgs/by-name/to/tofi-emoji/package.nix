{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  tofi,
  wl-clipboard,
  wtype,
  gawk,
  coreutils,
  gnused,
}:

let
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "noahpro99";
    repo = "tofi-emoji";
    rev = "275b8ca9dd67ac26683c9b498bf3528529735305";
    hash = "sha256-LhVeA5m5wTSMjH/w20hyITCkVxStSGgM6HqNmbmGrV8=";
  };

  emojiTest = fetchurl {
    url = "https://unicode.org/Public/emoji/15.1/emoji-test.txt";
    sha256 = "sha256-2HbuJJqijqp2z6bfqnAoR6jROwYqpIjUZdA5XugTftk=";
  };
in
stdenv.mkDerivation {
  pname = "tofi-emoji";
  inherit version src;

  buildInputs = [
    tofi
    wl-clipboard
    wtype
    gawk
    coreutils
    gnused
  ];

  dontBuild = true;

  postPatch = ''
    patchShebangs scripts

    # Substitute binary paths
    substituteInPlace scripts/tofi-emoji \
      --replace-fail 'tofi ' '${tofi}/bin/tofi ' \
      --replace-fail 'wl-copy' '${wl-clipboard}/bin/wl-copy' \
      --replace-fail 'wtype' '${wtype}/bin/wtype' \
      --replace-fail 'cut ' '${coreutils}/bin/cut ' \
      --replace-fail 'sed ' '${gnused}/bin/sed ' \
      --replace-fail 'TOFI_EMOJI_CACHE_HELPER:-tofi-emoji-cache' 'TOFI_EMOJI_CACHE_HELPER:-$out/bin/tofi-emoji-cache'

    substituteInPlace scripts/build-emoji-cache \
      --replace-fail 'gawk' '${gawk}/bin/gawk' \
      --replace-fail 'TOFI_EMOJI_UNICODE_FILE:-}' 'TOFI_EMOJI_UNICODE_FILE:-${emojiTest}}'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 scripts/tofi-emoji $out/bin/tofi-emoji
    install -Dm755 scripts/build-emoji-cache $out/bin/tofi-emoji-cache

    runHook postInstall
  '';

  meta = {
    description = "Emoji picker for Wayland using tofi";
    homepage = "https://github.com/noahpro/tofi-emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noahpro99 ];
    platforms = lib.platforms.linux;
    mainProgram = "tofi-emoji";
  };
}
