{ lib, stdenv, fetchFromGitHub, nasm, windows }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l64xP39Uaislqh4D7oSxJiQGhXkklol4LgS9BVPbaGk=";
  };

  nativeBuildInputs = [ nasm ];

  buildInputs = lib.optional stdenv.hostPlatform.isWindows windows.pthreads;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ] ++ lib.optional stdenv.hostPlatform.isWindows "OS=mingw_nt";

  enableParallelBuilding = true;

  hardeningDisable = lib.optional stdenv.hostPlatform.isWindows "stackprotector";

  meta = with lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = "https://www.openh264.org";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
