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
  version = "unstable-2021-11-06";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "8ad8f5f5eff9d1625abc57cb24dc484d51f0e1bd";
    sha256 = "0xbskf7jd03d2invfz1nnfc82klzvc784snw539n4kn6c6rc381p";
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
