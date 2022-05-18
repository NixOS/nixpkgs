{ lib, stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.1.5";
  pname = "nanomsg";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "01ddfzjlkf2dgijrmm3j3j8irccsnbgfvjcnwslsfaxnrmrq5s64";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/nanomsg/nanomsg/issues/1082
  postPatch = ''
    substituteInPlace src/pkgconfig.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description= "Socket library that provides several common communication patterns";
    homepage = "https://nanomsg.org/";
    license = licenses.mit;
    mainProgram = "nanocat";
    platforms = platforms.unix;
  };
}
