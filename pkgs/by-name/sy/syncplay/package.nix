{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  qt6,
  enableGUI ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "syncplay";
  version = "1.7.4";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-23OTj+KUmYtrhzIS4A9Gq/tClOLwaeo50+Fcm1tn47M=";
  };

  patches = [
    ./trusted_certificates.patch
  ];

  buildInputs = lib.optionals enableGUI [
    (if stdenv.hostPlatform.isLinux then qt6.qtwayland else qt6.qtbase)
  ];
  dependencies =
    with python3Packages;
    [
      certifi
      pem
      twisted
    ]
    ++ twisted.optional-dependencies.tls
    ++ lib.optional enableGUI pyside6
    ++ lib.optional (stdenv.hostPlatform.isDarwin && enableGUI) appnope;
  nativeBuildInputs = lib.optionals enableGUI [ qt6.wrapQtAppsHook ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postFixup = lib.optionalString enableGUI ''
    wrapQtApp $out/bin/syncplay
  '';

  meta = {
    homepage = "https://syncplay.pl/";
    description = "Free software that synchronises media players";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ assistant ];
  };
})
