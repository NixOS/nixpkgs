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
  version = "unstable-2022-06-17";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "015ef5cd65e9ec89e4a1ae057f2251eda03715e2";
    hash = "sha256-NJ7icavofSUPPww1Ro7p0yY2EQ78S4KVCuj9yPuYwd8=";
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
