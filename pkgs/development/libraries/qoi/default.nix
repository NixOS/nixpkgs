{ fetchFromGitHub
, lib
, stb
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qoi";
  version = "unstable-2023-08-10";  # no upstream version yet.

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "qoi";
    rev = "19b3b4087b66963a3699ee45f05ec9ef205d7c0e";
    hash = "sha256-E1hMtjMuDS2zma2s5hlHby/sroRGhtyZm9gLQ+VztsM=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ stb ];

  buildPhase = ''
    runHook preBuild

    make CFLAGS_CONV="-I${stb}/include/stb -O3" qoiconv

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Conversion utility for images->qoi. Not usually needed for development.
    mkdir -p ${placeholder "out"}/bin
    install qoiconv ${placeholder "out"}/bin

    # The actual single-header implementation. Nothing to compile, just install.
    mkdir -p ${placeholder "dev"}/include/
    install qoi.h ${placeholder "dev"}/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "'Quite OK Image Format' for fast, lossless image compression";
    mainProgram = "qoiconv";
    homepage = "https://qoiformat.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ hzeller ];
    platforms = platforms.all;
  };
})
