{
  buildOctavePackage,
  stdenv,
  lib,
  fetchurl,
  gsl,
}:

buildOctavePackage rec {
  pname = "gsl";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1lvfxbqmw8h1nlrxmvrl6j4xffmbzxfhdpxz3vrc6lg2g4jwaa6h";
  };

  buildInputs = [
    gsl
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/gsl/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Octave bindings to the GNU Scientific Library";
    # error: use of undeclared identifier 'feval'; did you mean 'octave::feval'?
    # error: no member named 'is_real_type' in 'octave_value'
    broken = stdenv.isDarwin;
  };
}
