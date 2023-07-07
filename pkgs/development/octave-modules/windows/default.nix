{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-U5Fe5mTn/ms8w9j6NdEtiRFZkKeyV0I3aR+zYQw4yIs=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/windows/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
  };
}
