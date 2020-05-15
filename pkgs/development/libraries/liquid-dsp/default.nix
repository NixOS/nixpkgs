{stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "liquid-dsp";
  version = "20170307";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "8c1978fa4f5662b8849fe712be716958f29cec0e";
    sha256 = "0zpxvdsrw0vzzp3iaag3wh4z8ygl7fkswgjppp2fz2zhhqh93k2w";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };

}
