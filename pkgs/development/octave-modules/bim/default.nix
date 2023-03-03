{ buildOctavePackage
, lib
, fetchurl
, fpl
, msh
}:

buildOctavePackage rec {
  pname = "bim";
  version = "1.1.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0y70w8mj80c5yns1j7nwngwwrxp1pa87kyz2n2yvmc3zdigcd6g8";
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
