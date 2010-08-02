{ stdenv, fetchurl, SDL, libpng, libjpeg, libtiff, libungif, libXpm }:

stdenv.mkDerivation rec {
  pname = "SDL_image";
  version = "1.2.6";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.libsdl.org/projects/${pname}/release/${name}.tar.gz";
    sha256 = "1i3f72dw3i3l6d77dk81gw57sp0629rng9k76qb37brlz7dv3z48";
  };

  buildInputs = [SDL libpng libjpeg libtiff libungif libXpm];

  postInstall = "ln -s $out/include/SDL/SDL_image.h $out/include/";

  meta = {
    description = "SDL image library";
  };
}
