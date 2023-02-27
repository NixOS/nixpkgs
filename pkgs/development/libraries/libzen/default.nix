{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.4.40";
  pname = "libzen";
  src = fetchurl {
    url = "https://mediaarea.net/download/source/libzen/${version}/libzen_${version}.tar.bz2";
    sha256 = "sha256-VUPixFIUudnwuk9D3uYdApbh/58UJ+1sh53dG2K59p4=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  configureFlags = [ "--enable-shared" ];

  sourceRoot = "./ZenLib/Project/GNU/Library/";

  preConfigure = "sh autogen.sh";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Shared library for libmediainfo and mediainfo";
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
  };
}
