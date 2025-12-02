{
  lib,
  stdenv,
  clangStdenv,
  lld,
  # Available labels: https://github.com/yaneurao/YaneuraOu/blob/59f6265cebbd4f03138091098059a881a021eefa/source/Makefile#L53-L92
  targetLabel ?
    with stdenv.hostPlatform;
    if isDarwin then
      if isAarch64 then
        "APPLEM1"
      else if avx2Support then
        "APPLEAVX2"
      else
        "APPLESSE42"
    else if isx86_64 then
      if avx512Support then
        "AVX512"
      else if avx2Support then
        "AVX2"
      else if sse4_2Support then
        "SSE42"
      else if sse4_1Support then
        "SSE41"
      else if ssse3Support then
        "SSSE3"
      else
        "SSE2"
    else if isx86_32 then
      "NO_SSE"
    else
      "OTHER",
  fetchFromGitHub,
  fetchurl,
  _7zz,
  nix-update-script,
}:

# Use clangStdenv instead of the default stdenv because:
# - The upstream author treats clang++ as the primary compiler in the docs
#   and Makefile, even though the code also builds with g++.
# - With just stdenv the build fails on macOS, while it works out of the box
#   with clangStdenv.
clangStdenv.mkDerivation (finalAttrs: {
  pname = "yaneuraou";
  version = "9.01";

  src = fetchFromGitHub {
    owner = "yaneurao";
    repo = "YaneuraOu";
    tag = "v${finalAttrs.version}git";
    hash = "sha256-uhr3jS+ttN5pF1zZpHq2xWy3sdMV19eRUhuj2uPspak=";
  };

  sourceRoot = "${finalAttrs.src.name}/source";

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    lld
  ];

  buildInputs = [
    stdenv.cc.cc # For libstdc++.so.6
  ];

  buildFlags = [
    "TARGET_CPU=${targetLabel}"
    "YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE"
    "COMPILER=clang++"
    "OBJDIR=$NIX_BUILD_TOP/obj"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv ./YaneuraOu-by-* "$out/bin/YaneuraOu"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    _7zz
  ];
  installCheckPhase =
    let
      nnue = fetchurl {
        url = "https://github.com/yaneurao/YaneuraOu/releases/download/suisho5/Suisho5.7z";
        hash = "sha256-ZzTjo9KOZ7kgbDRC9tEPFhSBODJ9/4Ecre389YH3mAk=";
      };
    in
    ''
      runHook preInstallCheck

      7zz x '${nnue}'
      usi_command="setoption name EvalDir value $PWD
      isready
      go byoyomi 1000
      wait"
      usi_output="$("$out/bin/YaneuraOu" <<< "$usi_command")"
      [[ "$usi_output" == *'bestmove'* ]]

      runHook postInstallCheck
    '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([\\d.]+)git$"
      ];
    };
  };

  meta = {
    description = "USI compliant shogi engine";
    homepage = "https://github.com/yaneurao/YaneuraOu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "YaneuraOu";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
