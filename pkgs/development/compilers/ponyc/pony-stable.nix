{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation {
  name = "pony-stable-unstable-2017-07-26";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = "4016f9253a4e3114ee69100d3d02154ffd3fd7e4";
    sha256 = "0xz5syjn2f8k31vny49k3jm8zisa15ly4hbcb3rh4jvq8jjp1ldr";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.dipinhora ];
    platforms = stdenv.lib.platforms.unix;
  };
}
