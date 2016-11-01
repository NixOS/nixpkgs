{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  version = "0.3.3";
  name = "loc-${version}";

  src = fetchFromGitHub {
    owner = "cgag";
    repo = "loc";
    rev = "e2dfe2c1452f25f58974b545292b11dc450afd3d";
    sha256 = "1kp5iawig6304gs1289aivgsq44zhnn0ykqv9ymwpvj0g12l4l8r";
  };

  depsSha256 = "01jww6d4dzb5pq6vcrp3xslhxic0vp0gicsddda4adzqg1lab8c2";

  meta = {
    homepage = "http://github.com/cgag/loc";
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

