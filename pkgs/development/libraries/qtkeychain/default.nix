{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qtbase,
  qttools,
  libsecret,
}:

stdenv.mkDerivation rec {
  pname = "qtkeychain";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = version;
    sha256 = "sha256-/gdozAJbjaaCcttQED2PixaFNRDZOXbBIoV9QLexNUg=";
  };

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DBUILD_WITH_QT6=${if lib.versions.major qtbase.version == "6" then "ON" else "OFF"}"
    "-DQT_TRANSLATIONS_DIR=share/qt/translations"
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ] # for finding libsecret
  ;

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libsecret ] ++ [
    qtbase
    qttools
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
