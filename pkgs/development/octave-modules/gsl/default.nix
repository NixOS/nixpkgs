{
  buildOctavePackage,
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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/gsl/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Octave bindings to the GNU Scientific Library";
    # When used in an `octave.withPackages` environment, octave fails to find
    # libgsl.so from some reason.
    broken = true;
  };
}
