{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation (rec {
  pname = "rnnoise";
  version = "2021-01-22";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rnnoise";
    rev = "1cbdbcf1283499bbb2230a6b0f126eb9b236defd";
    sha256 = "1y0rzgmvy8bf9a431garpm2w177s6ajgf79y5ymw4yb0pik57rwb";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
    install -Dt $out/bin examples/.libs/rnnoise_demo
  '';

  meta = with lib; {
    description = "Recurrent neural network for audio noise reduction";
    homepage = "https://people.xiph.org/~jm/demo/rnnoise/";
    license = licenses.bsd3;
    maintainers = [ maintainers.nh2 ];
    mainProgram = "rnnoise_demo";
    platforms = platforms.all;
  };
})
