{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  enchant,
  qttools,
  pkg-config,
  withDocs ? false,
  doxygen,
  glib,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "qtspell";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "manisandro";
    repo = "qtspell";
    rev = "${version}";
    hash = "sha256-yaR3eCUbK2KTpvzO2G5sr+NEJ2mDnzJzzzwlU780zqU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      pkg-config
      enchant
      qttools
    ]
    ++ lib.optional withDocs doxygen
    ++ lib.optionals stdenv.isDarwin [
      glib
      llvmPackages.clang
    ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Provides spell-checking to Qt's text widgets, using the enchant spell-checking library";
    homepage = "https://github.com/manisandro/qtspell";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
