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

  propagatedBuildInputs = [
    gsl
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/gsl/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Octave bindings to the GNU Scientific Library";
    # gsl_sf.cc:1782:11: error: no member named 'is_real_type' in 'octave_value'
    #  1782 |     if (! ISREAL(args(i)))
    #       |           ^~~~~~~~~~~~~~~
    broken = stdenv.hostPlatform.isDarwin;
  };
}
