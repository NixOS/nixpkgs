{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  qt6,
  enableGUI ? true,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "syncplay";
  version = "1.7.5";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-qNkucK7+OuNmTGLuTn4hXxKjMq3WpT4CvGRXoQ2+1Oc=";
  };

  patches = [
    ./trusted_certificates.patch
    # https://github.com/Syncplay/syncplay/pull/775
    # Remove next update
    (fetchpatch {
      name = "pyopenssl_fix.patch";
      url = "https://patch-diff.githubusercontent.com/raw/Syncplay/syncplay/pull/775.patch";
      hash = "sha256-6bJZtWgb9e7ZK51xjkghloIVQRdLI2UJiVa4fyxDa5w=";
    })
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
