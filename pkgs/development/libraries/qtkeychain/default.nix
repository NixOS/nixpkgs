{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, qt4 ? null
, withQt5 ? false, qtbase ? null, qttools ? null
, darwin ? null
, libsecret
}:

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;
assert stdenv.isDarwin -> darwin != null;

stdenv.mkDerivation rec {
  name = "qtkeychain-${if withQt5 then "qt5" else "qt4"}-${version}";
  version = "0.9.1";            # verify after nix-build with `grep -R "set(PACKAGE_VERSION " result/`

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "0h4wgngn2yl35hapbjs24amkjfbzsvnna4ixfhn87snjnq5lmjbc"; # v0.9.1
  };

  dontWrapQtApps = true;

  patches = (if withQt5 then [] else [ ./0001-Fixes-build-with-Qt4.patch ]) ++ (if stdenv.isDarwin then [ ./0002-Fix-install-name-Darwin.patch ] else []);

  cmakeFlags = [ "-DQT_TRANSLATIONS_DIR=share/qt/translations" ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals (!stdenv.isDarwin) [ pkg-config ] # for finding libsecret
  ;

  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ (if withQt5 then [ qtbase qttools ] else [ qt4 ])
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation Security
    ])
  ;

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = "https://github.com/frankosterfeld/qtkeychain";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
