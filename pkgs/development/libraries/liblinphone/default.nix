{ lib
, bc-soci
, belcard
, belle-sip
, cmake
, doxygen
, fetchFromGitLab
, jsoncpp
, libxml2
, lime
, mediastreamer
, python3
, sqlite
, stdenv
, xercesc
, zxing-cpp
}:

stdenv.mkDerivation rec {
  pname = "liblinphone";
  version = "5.2.98";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    hash = "sha256-kQZePMa7MTaSJLEObM8khfSFYLqhlgTcVyKfTPLwKYU=";
  };

  patches = [
    # zxing-cpp 2.0+ requires C++ 17
    # Manual backport as upstream ran formatters in the meantime
    ./backport-cpp17.patch
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "jsoncpp_object" "jsoncpp" \
      --replace "jsoncpp_static" "jsoncpp"
  '';

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
    "-DENABLE_STRICT=NO" # Do not build with -Werror
  ];

  buildInputs = [
    # Made by BC
    belcard
    belle-sip
    lime
    mediastreamer

    # Vendored by BC
    bc-soci

    jsoncpp
    libxml2
    (python3.withPackages (ps: [ ps.pystache ps.six ]))
    sqlite
    xercesc
    zxing-cpp
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  strictDeps = true;

  # Some grammar files needed to be copied too from some dependencies. I suppose
  # if one define a dependency in such a way that its share directory is found,
  # then this copying would be unnecessary. Instead of actually copying these
  # files, create a symlink.
  postInstall = ''
    mkdir -p $out/share/belr/grammars
    ln -s ${belcard}/share/belr/grammars/* $out/share/belr/grammars/
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/technical-corner/liblinphone";
    description = "Library for SIP calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
