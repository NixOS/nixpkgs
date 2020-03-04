{ stdenv
, fetchFromGitHub
, cmake
, boost
, expat
, zlib
, uriparser
, minizip
, gtest
}:

stdenv.mkDerivation rec {
  pname = "libkml";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "libkml";
    repo = pname;
    rev = version;
    sha256 = "0gl4cqfps9mzx6hzf3dc10hy5y8smpyf1s31sqm7w343hgsllv0z";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  ];

  buildInputs = [
    gtest
    boost
    expat
    zlib
    uriparser
    minizip
  ];

  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/lib
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Reference implementation of OGC KML 2.2";
    homepage = https://github.com/libkml/libkml;
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.all;
  };
}
