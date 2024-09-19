{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,

  enablePython ? false,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libplist";
  version = "2.6.0-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "libplist";
    rev = "e8791e2d8b1d1672439b78d31271a8cf74d6a16d";
    hash = "";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ] ++ lib.optional enablePython "py";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals enablePython [
    python3
    python3.pkgs.cython
  ];

  doCheck = true;

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  configureFlags =
    [
      "--enable-debug"
    ]
    ++ lib.optionals (!enablePython) [
      "--without-cython"
    ];

  postFixup = lib.optionalString enablePython ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = with lib; {
    description = "Library to handle Apple Property List format in binary or XML";
    homepage = "https://github.com/libimobiledevice/libplist";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
    mainProgram = "plistutil";
  };
})
