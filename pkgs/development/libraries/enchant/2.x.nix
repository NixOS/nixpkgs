{
  stdenv,
  lib,
  fetchurl,
  aspell,
  groff,
  pkg-config,
  glib,
  hunspell,
  hspell,
  nuspell,
  unittest-cpp,

  withHspell ? true,
  withAspell ? true,
  withHunspell ? true,
  withNuspell ? true,
  withAppleSpell ? stdenv.hostPlatform.isDarwin,

  Cocoa,
}:

assert withAppleSpell -> stdenv.hostPlatform.isDarwin;

stdenv.mkDerivation rec {
  pname = "enchant";
  version = "2.6.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-2aWhDcmzikOzoPoix27W67fgnrU1r/YpVK/NvUDv/2s=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    groff
    pkg-config
  ];

  buildInputs =
    [
      glib
    ]
    ++ lib.optionals withHunspell [
      hunspell
    ]
    ++ lib.optionals withNuspell [
      nuspell
    ]
    ++ lib.optionals withAppleSpell [
      Cocoa
    ];

  checkInputs = [
    unittest-cpp
  ];

  # libtool puts these to .la files
  propagatedBuildInputs =
    lib.optionals withHspell [
      hspell
    ]
    ++ lib.optionals withAspell [
      aspell
    ];

  enableParallelBuilding = true;

  doCheck = true;

  configureFlags = [
    "--enable-relocatable" # needed for tests
    (lib.withFeature withAspell "aspell")
    (lib.withFeature withHspell "hspell")
    (lib.withFeature withHunspell "hunspell")
    (lib.withFeature withNuspell "nuspell")
    (lib.withFeature withAppleSpell "applespell")
  ];

  meta = with lib; {
    description = "Generic spell checking library";
    homepage = "https://rrthomas.github.io/enchant/";
    license = licenses.lgpl21Plus; # with extra provision for non-free checkers
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
