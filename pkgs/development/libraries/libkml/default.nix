{ lib, stdenv
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
  version = "unstable-2017-01-15";

  src = fetchFromGitHub {
    owner = "libkml";
    repo = pname;
    rev = "916a801ed3143ab82c07ec108bad271aa441da16";
    sha256 = "0kgpmmc6dxnpqj90yplg3018d9cyykp6xd2cws49iv91w5k2c11v";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  # Darwin tests require rpath for libs in build dir
  ] ++ lib.optional stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
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

  meta = with lib; {
    description = "Reference implementation of OGC KML 2.2";
    homepage = "https://github.com/libkml/libkml";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.all;
  };
}
