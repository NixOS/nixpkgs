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
  version = "2.1.55";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${version}";
    sha256 = "sha256-fNVhsZPjqdMOmESy/MinjdaNE5jWMWSeVidAs9JGV38=";
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
