{
  lib,
  stdenv,
  fetchFromGitHub,
  zip,
  copyDesktopItems,
  libpng,
  SDL2,
  SDL2_image,

  # Optionally bundle a ROM file
  romFile ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tamatool";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "jcrona";
    repo = "tamatool";
    # New versions are not tagged
    rev = "6941aab9dd54f72b33a3251679edfcc87dcadf8d";
    hash = "sha256-lHKGV+AuD0wBBJP2IIo48/DJVVSQupY8rBJTYXdheX0=";
    fetchSubmodules = true;
  };

  # * Point to the installed rom and res directory
  # * Tell the user to use --rom instead of telling them to place the rom in the
  #   program directory (it's immutable!)
  postPatch = ''
    substituteInPlace src/tamatool.c \
      --replace-fail '#define RES_PATH'          "#define RES_PATH         \"$out/share/tamatool/res\"          //" \
      --replace-fail '#define ROM_PATH'          "#define ROM_PATH         \"$out/share/tamatool/rom.bin\"      //" \
      --replace-fail '#define ROM_NOT_FOUND_MSG' '#define ROM_NOT_FOUND_MSG "You need to use the --rom option!" //'
  '';

  nativeBuildInputs = [
    zip
    copyDesktopItems
  ];

  buildInputs = [
    libpng
    SDL2
    SDL2_image
  ];

  makeFlags = [
    "-Clinux"
    "VERSION=${finalAttrs.version}"
    "CFLAGS+=-I${lib.getInclude SDL2}/include/SDL2"
    "CFLAGS+=-I${lib.getInclude SDL2_image}/include/SDL2"
    "DIST_PATH=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-framework CoreFoundation";
  };

  desktopItems = [ "linux/tamatool.desktop" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 linux/tamatool $out/bin/tamatool
    mkdir -p $out/share/tamatool
    cp -r res $out/share/tamatool/res
    install -Dm644 linux/tamatool.png $out/share/icons/hicolor/128x126/apps/tamatool.png
    ${lib.optionalString (romFile != null) "install -Dm677 ${romFile} $out/share/tamatool/rom.bin"}
    runHook postInstall
  '';

  meta = {
    description = "Cross-platform Tamagotchi P1 explorer";
    homepage = "https://github.com/jcrona/tamatool";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "tamatool";
  };
})
