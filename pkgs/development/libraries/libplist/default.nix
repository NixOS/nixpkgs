{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  python3,
  enablePython ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libplist";
  version = "2.6.0-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libplist";
    rev = "e8791e2d8b1d1672439b78d31271a8cf74d6a16d";
    hash = "sha256-sKLFfv+B5UuYjMxG8a6GbP6BvohkhkqjS5+RBncHvxI=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ] ++ lib.optional enablePython "py";
  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

  configureFlags =
    [
      "--enable-debug"
    ]
    ++ lib.optionals (!enablePython) [
      "--without-cython"
    ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/libplist";
    description = "Library to handle Apple Property List format in binary or XML";
    license = with licenses; [
      gpl2Only
      lgpl21Only
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
    mainProgram = "plistutil";
  };
})
