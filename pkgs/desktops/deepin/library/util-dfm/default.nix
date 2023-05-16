{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, libmediainfo
, libsecret
, libisoburn
, libuuid
, udisks
}:

stdenv.mkDerivation rec {
  pname = "util-dfm";
<<<<<<< HEAD
  version = "1.2.12";
=======
  version = "1.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-juZQCRtr0SWrPAz6PAAw2m/MWoTg7831BizziHsId00=";
=======
    sha256 = "sha256-Mc3x0nTnEyMnruZotiT1J4BGOeNAQlCXGbO0yVJtqYM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qtbase
    libmediainfo
    libsecret
    libuuid
    libisoburn
    udisks
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPROJECT_VERSION=${version}"
  ];

  meta = with lib; {
    description = "A Toolkits of libdfm-io,libdfm-mount and libdfm-burn";
    homepage = "https://github.com/linuxdeepin/util-dfm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
