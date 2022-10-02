{ bctoolbox
, belcard
, belle-sip
, belr
, cmake
, doxygen
, fetchFromGitLab
, jsoncpp
, libxml2
, lime
, mediastreamer
, python3
, bc-soci
, sqlite
, lib
, stdenv
, xercesc
}:

stdenv.mkDerivation rec {
  pname = "liblinphone";
  version = "5.1.22";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = version;
    sha256 = "sha256-hTyp/fUA1+7J1MtqX33kH8Vn1XNjx51Wy5REvrpdJTY=";
  };

  patches = [ ./use-normal-jsoncpp.patch ];

  cmakeFlags = [
    "-DENABLE_STATIC=NO" # Do not build static libraries
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
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
