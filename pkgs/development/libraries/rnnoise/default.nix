{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation (rec {
  pname = "rnnoise";
  version = "2020-06-28";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rnnoise";
    rev = "90ec41ef659fd82cfec2103e9bb7fc235e9ea66c";
    sha256 = "02z6qzjajhlpsb80lwl7cqqga9hm638psnqnppjkw84w4lrp15ny";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  meta = with lib; {
    homepage = "https://people.xiph.org/~jm/demo/rnnoise/";
    description = "Recurrent neural network for audio noise reduction";
    license = licenses.bsd3;
    maintainers = [ maintainers.nh2 ];
    platforms = platforms.all;
  };
})
