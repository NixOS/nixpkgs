{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, CoreFoundation
, Security
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "qtkeychain";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "0gi1nx4bcc1vwfw41cif3xi2i59229vy0kc2r5959d8n6yv31kfr"; # v0.9.1
  };

  dontWrapQtApps = true;

  patches = [ ./0002-Fix-install-name-Darwin.patch ];

  cmakeFlags = [
    "-DBUILD_WITH_QT6=${if lib.versions.major qtbase.version == "6" then "ON" else "OFF"}"
    "-DQT_TRANSLATIONS_DIR=share/qt/translations"
  ];

  nativeBuildInputs = [ cmake ]
    ++ lib.optionals (!stdenv.isDarwin) [ pkg-config ] # for finding libsecret
  ;

  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ [ qtbase qttools ]
    ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
  ];

  doInstallCheck = true;

  # we previously had a note in here saying to run this check manually, so we might as
  # well do it automatically. It seems like a perfectly valid sanity check, but I
  # have no idea *why* we might need it
  installCheckPhase = ''
    runHook preInstallCheck

    grep --quiet -R 'set(PACKAGE_VERSION "${version}"' .

    runHook postInstallCheck
  '';

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = "https://github.com/frankosterfeld/qtkeychain";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
