{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  enchant,
  glib,
  llvmPackages,
  pkg-config,
  qtbase,
  qttools,
}:

stdenv.mkDerivation rec {
  pname = "qtspell";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "manisandro";
    repo = "qtspell";
    rev = "${version}";
    hash = "sha256-OuEGY+0XJo3EUUcH8xAzlgE6zKPndBvG0arWhG/QO6Y=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    qttools
  ];

  buildInputs = [
    enchant
    qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    glib
    llvmPackages.clang
  ];

  cmakeFlags = [ "-DQT_VER=6" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Provides spell-checking to Qt's text widgets, using the enchant spell-checking library";
    homepage = "https://github.com/manisandro/qtspell";
    changelog = "https://github.com/manisandro/qtspell/blob/version/NEWS";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
