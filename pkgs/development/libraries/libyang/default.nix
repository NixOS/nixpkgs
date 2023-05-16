{ stdenv
, lib
, fetchFromGitHub

# build time
, cmake
, pkg-config

# run time
, pcre2

# update script
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libyang";
<<<<<<< HEAD
  version = "2.1.111";
=======
  version = "2.1.55";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-CJAIlEPbrjc2juYiPOQuQ0y7ggOxb/fHb7Yoo6/dYQc=";
=======
    sha256 = "sha256-fNVhsZPjqdMOmESy/MinjdaNE5jWMWSeVidAs9JGV38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pcre2
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_BUILD_TYPE:String=Release"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "YANG data modelling language parser and toolkit";
    longDescription = ''
      libyang is a YANG data modelling language parser and toolkit written (and
      providing API) in C. The library is used e.g. in libnetconf2, Netopeer2,
      sysrepo or FRRouting projects.
    '';
    homepage = "https://github.com/CESNET/libyang";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ woffs ];
  };
}
