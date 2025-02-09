{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kwin
, lib
}:

stdenv.mkDerivation rec {
  pname = "sierra-breeze-enhanced";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    rev = "V${version}";
    sha256 = "sha256-zTUTsSzy4p0Y7RPOidCtxTjjyvPRyWSQCxA5sUzXcLc=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
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
    maintainers = with maintainers; [ flexagoon ];
  };
}
