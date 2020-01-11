{ stdenv, lib, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation (rec {
  name = "rnnoise-${version}";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rnnoise";
    rev = "91ef401f4c3536c6de999ac609262691ec888c4c";
    sha256 = "1h2ibg67gfcwnpvkq1rx0sngf9lk9j8pqsmsmmk5hclvrr2lp3yb";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = https://people.xiph.org/~jm/demo/rnnoise/;
    description = "Recurrent neural network for audio noise reduction.";
    license = licenses.bsd3;
    maintainers = [ maintainers.nh2 ];
    platforms = platforms.all;
  };
})
