{
  buildOctavePackage,
  lib,
  fetchurl,
  dolfin,
  ffc,
  pkg-config,
}:

buildOctavePackage rec {
  pname = "fem-fenics";
  version = "0.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1xd80nnkschldvrqx0wvrg3fzbf8sck8bvq24phr5x49xs7b8x78";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    dolfin
    ffc
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/fem-fenics/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Package for the resolution of partial differential equations based on fenics";
    # Lots of compilation errors for newer octave versions and syntax errors
    broken = true;
  };
}
