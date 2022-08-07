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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "kupiqu";
    repo = "SierraBreezeEnhanced";
    rev = "V${version}";
    sha256 = "sha256-G1Ra7ld34AMPLZM0+3iEJHRFRMHVewZKTTXfmiu7PAk=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DCMAKE_BUILD_TYPE=Release"
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
