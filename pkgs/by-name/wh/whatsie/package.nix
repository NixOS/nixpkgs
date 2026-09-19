{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  qt6,
  linkFarm,
  hunspellDictsChromium,
  dictionaries ? [
    hunspellDictsChromium.en-us
  ],
}:

let
  qtwebengineDictionaries = linkFarm "whatsie-qtwebengine-dictionaries" (
    map (d: {
      name = d.dictFileName;
      path = d;
    }) dictionaries
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "whatsie";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aOhMov7P3zFeWfnDXzBL0pIQu+G2D4tPhBIlY9cuYKQ=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwebengine
  ];

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    runHook preCheck

    ctest --output-on-failure --exclude-regex '^tst_(permissions|freedesktop_notifier)$'

    runHook postCheck
  '';

  postInstall = lib.optionalString (dictionaries != [ ]) ''
    install -Dm444 -t $out/share/whatsie/qtwebengine_dictionaries \
      ${qtwebengineDictionaries}/*.bdic
  '';

  meta = {
    homepage = "https://github.com/keshavbhatt/whatsie";
    description = "Feature rich WhatsApp Client for Desktop Linux";
    license = lib.licenses.mit;
    mainProgram = "whatsie";
    maintainers = with lib.maintainers; [ ajgon ];
    platforms = lib.platforms.linux;
  };
})
