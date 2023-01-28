{ lib, stdenv, fetchFromGitHub, boost, libxml2, pkg-config, docbook2x, curl, autoreconfHook, cppunit }:

stdenv.mkDerivation rec {
  pname = "libcmis";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "tdf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s6prfh55hn11vrs72ph1gs01v0vngly81pvyjm5v1sgwymdxx57";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config docbook2x ];
  buildInputs = [ boost libxml2 curl cppunit ];

  configureFlags = [
    "--disable-werror"
    "DOCBOOK2MAN=${docbook2x}/bin/docbook2man"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C++ client library for the CMIS interface";
    homepage = "https://github.com/tdf/libcmis";
    license = licenses.gpl2;
    mainProgram = "cmis-client";
    platforms = platforms.unix;
  };
}
