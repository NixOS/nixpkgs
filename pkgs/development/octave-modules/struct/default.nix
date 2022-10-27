{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "struct";
  version = "1.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0cw4cspkm553v019zsj2bsmal0i378pm0hv29w82j3v5vysvndq1";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/struct/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Additional structure manipulation functions";
  };
}
