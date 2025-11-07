{
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  kwin,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "sierra-breeze-enhanced";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    rev = if version == "2.1.1" then "V.2.1.1" else "V${version}";
    hash = "sha256-7mQnJCQr/zm9zEdg2JPr7jQn8uajyCXvyYRQZWxG+Q8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [ kwin ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  meta = with lib; {
    description = "OSX-like window decoration for KDE Plasma written in C++";
    homepage = "https://github.com/kupiqu/SierraBreezeEnhanced";
    changelog = "https://github.com/kupiqu/SierraBreezeEnhanced/releases/tag/V${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ A1ca7raz ];
  };
}
