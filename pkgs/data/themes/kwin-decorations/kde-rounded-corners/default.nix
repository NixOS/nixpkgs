{ stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kwin
, kdelibs4support
, libepoxy
, libxcb
, lib
}:

stdenv.mkDerivation rec {
  pname = "kde-rounded-corners";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-5b23QCyjPMC6iba84Y2WEar5uXzxg2GonRv3e4mLQlQ=";
  };

  postConfigure = ''
    substituteInPlace cmake_install.cmake \
      --replace "${kdelibs4support}" "$out"
  '';

  nativeBuildInputs = [ cmake extra-cmake-modules wrapQtAppsHook ];
  buildInputs = [ kwin kdelibs4support libepoxy libxcb ];

  meta = with lib; {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ flexagoon ];
  };
}
