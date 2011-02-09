{ stdenv, fetchurl, SDL, libpng, libjpeg, libtiff, libungif, libXpm }:

stdenv.mkDerivation rec {
  pname = "SDL_image";
  version = "1.2.10";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/${pname}/release/${name}.tar.gz";
    sha256 = "0xhqw56xgc0rn3ziccirib8ai2whbbidjmvig527n9znjlg5vq3m";
  };

  buildInputs = [SDL libpng libjpeg libtiff libungif libXpm];

  postInstall = "ln -sv $out/include/SDL/SDL_image.h $out/include/";

  meta = {
    description = "SDL image library";
  };
}
