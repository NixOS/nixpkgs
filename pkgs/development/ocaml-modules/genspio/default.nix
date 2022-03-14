{ lib, fetchFromGitHub, buildDunePackage
, nonstd, sosa
}:

buildDunePackage rec {
  pname = "genspio";
  version = "0.0.2";

  useDune2 = false;

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = pname;
    rev = "${pname}.${version}";
    sha256 = "0cp6p1f713sfv4p2r03bzvjvakzn4ili7hf3a952b3w1k39hv37x";
  };

  minimalOCamlVersion = "4.03";

  propagatedBuildInputs = [ nonstd sosa ];

  configurePhase = ''
    ocaml please.mlt configure
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://smondet.gitlab.io/genspio-doc/";
    description = "Typed EDSL to generate POSIX Shell scripts";
    license = licenses.asl20;
    maintainers = [ maintainers.alexfmpe ];
  };
}
