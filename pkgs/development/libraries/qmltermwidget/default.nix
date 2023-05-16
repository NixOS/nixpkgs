<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qtquick1
, qmake
, qtmultimedia
, utmp
}:

stdenv.mkDerivation {
  pname = "qmltermwidget";
  version = "unstable-2022-01-09";
=======
{ lib, stdenv, fetchFromGitHub, qtbase, qtquick1, qmake, qtmultimedia, utmp, fetchpatch }:

stdenv.mkDerivation {
  version = "2018-11-24";
  pname = "qmltermwidget-unstable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "qmltermwidget";
    owner = "Swordfish90";
<<<<<<< HEAD
    rev = "63228027e1f97c24abb907550b22ee91836929c5";
    hash = "sha256-aVaiRpkYvuyomdkQYAgjIfi6a3wG2a6hNH1CfkA2WKQ=";
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [
    qtbase
    qtquick1
    qtmultimedia
  ] ++ lib.optional stdenv.isDarwin utmp;

  patches = [
    # Some files are copied twice to the output which makes the build fails
    ./do-not-copy-artifacts-twice.patch
=======
    rev = "48274c75660e28d44af7c195e79accdf1bd44963";
    sha256 = "028nb1xp84jmakif5mmzx52q3rsjwckw27jdpahyaqw7j7i5znq6";
  };

  buildInputs = [ qtbase qtquick1 qtmultimedia ]
                ++ lib.optional stdenv.isDarwin utmp;
  nativeBuildInputs = [ qmake ];

  patches = [
    (fetchpatch {
      name = "fix-missing-includes.patch";
      url = "https://github.com/Swordfish90/qmltermwidget/pull/27/commits/485f8d6d841b607ba49e55a791f7f587e4e193bc.diff";
      sha256 = "186s8pv3642vr4lxsds919h0y2vrkl61r7wqq9mc4a5zk5vprinj";
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    substituteInPlace qmltermwidget.pro \
      --replace '$$[QT_INSTALL_QML]' "/$qtQmlPrefix/"
  '';

<<<<<<< HEAD
  installFlags = [ "INSTALL_ROOT=${placeholder "out"}" ];
=======
  installFlags = [ "INSTALL_ROOT=$(out)" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontWrapQtApps = true;

  meta = {
    description = "A QML port of qtermwidget";
    homepage = "https://github.com/Swordfish90/qmltermwidget";
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ skeidel ];
  };
}
