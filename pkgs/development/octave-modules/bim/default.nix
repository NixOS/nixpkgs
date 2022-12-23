{ buildOctavePackage
, lib
, fetchurl
, fpl
, msh
}:

buildOctavePackage rec {
  pname = "bim";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-pv64swrPlgopBlubpAlfoD9KJlOSgF9wdbgdHHTcr9c=";
  };

  requiredOctavePackages = [
    fpl
    msh
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/bim/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Package for solving Diffusion Advection Reaction (DAR) Partial Differential Equations";
  };
}
