{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kwin
, kdelibs4support
, libepoxy
, libXdmcp
, lib
}:

stdenv.mkDerivation rec {
  pname = "kde-rounded-corners";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-cXpJabeOHnat7OljtRzduUdOaA6Z3z6vV3aBKwiIrR0=";
  };

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${kdelibs4support}" "$out"
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin kdelibs4support libepoxy libXdmcp ];

  meta = with lib; {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flexagoon ];
  };
}
