{ buildOctavePackage
, lib
, fetchurl
, nan # > 3.0.0
}:

buildOctavePackage rec {
  pname = "tsa";
  version = "4.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0p2cjszzjwhp4ih3q3r67qnikgxc0fwxc12p3727jbdvzq2h10mn";
  };

  requiredOctavePackages = [
    nan
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/tsa/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Stochastic concepts and maximum entropy methods for time series analysis";
  };
}
