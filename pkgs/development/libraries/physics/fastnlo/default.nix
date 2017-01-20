{ stdenv, fetchurl, boost, lhapdf, root, yoda }:

stdenv.mkDerivation rec {
  name = "fastnlo_toolkit-${version}";
  version = "2.3.1pre-2212";

  src = fetchurl {
    url = "http://fastnlo.hepforge.org/code/v23/${name}.tar.gz";
    sha256 = "0xgnnwc002awvz6dhn7792jc8kdff843yjgvwmgcs60yvcj6blgp";
  };

  buildInputs = [ boost lhapdf root yoda ];

  CXXFLAGS="-std=c++11"; # for yoda

  configureFlags = [
    "--with-yoda=${yoda}"
  ];

  enableParallelBuilding = true;

  meta = {
    descritption = "A computer code to create and evaluate fast interpolation tables of pre-computed coefficients in perturbation theory for observables in hadron-induced processes";
    license      = stdenv.lib.licenses.gpl3;
    homepage     = http://fastnlo.hepforge.org;
    platforms    = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
