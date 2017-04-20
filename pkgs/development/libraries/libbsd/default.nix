{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.8.3";

  nativeBuildInputs = [ autoreconfHook ];

  preAutoreconf = "mkdir m4";

  patchPhase = ''
    substituteInPlace configure.ac \
      --replace "m4_esyscmd([./get-version])" "${version}"
    sed -i '38i#undef strlcpy' include/bsd/string.h
    sed -i '38i#undef strlcat' include/bsd/string.h
    substituteInPlace src/setproctitle.c \
     --replace 'extern typeof(setproctitle_impl) setproctitle_stub __attribute__((weak, alias("setproctitle_impl")));' ""
  '';

  src = fetchFromGitHub {
    owner = "JackieXie168";
    repo = "libbsd";
    rev = "macosx-${version}";
    sha256 = "1g5h6d7i297m0hs2l0dxvsx6p0z96959pzgp75drbb7mkrf32p2z";
  };

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = http://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
