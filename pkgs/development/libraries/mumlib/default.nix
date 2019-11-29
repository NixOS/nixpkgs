{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, boost, openssl, log4cpp, libopus, protobuf }:
with lib; stdenv.mkDerivation {
  pname = "mumlib";
  version = "unstable-2018-12-12";

  src = fetchFromGitHub {
    owner = "slomkowski";
    repo = "mumlib";
    rev = "f91720de264c0ab5e02bb30deafc5c4b2c245eac";
    sha256 = "0p29z8379dp2ra0420x8xjp4d3r2mf680lj38xmlc8npdzqjqjdp";
  };

  buildInputs = [ boost openssl libopus protobuf log4cpp ];
  nativeBuildInputs = [ cmake pkgconfig ];
  installPhase = ''
    install -Dm555 libmumlib.so $out/lib/libmumlib.so
    cp -a ../include $out
  '';

  meta = {
    description = "Fairy simple Mumble library written in C++, using boost::asio asynchronous networking framework";
    homepage = "https://github.com/slomkowski/mumlib";
    maintainers = with maintainers; [ das_j ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
