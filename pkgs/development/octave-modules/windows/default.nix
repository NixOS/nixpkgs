{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "110dh6jz088c4fxp9gw79kfib0dl7r3rkcavxx4xpk7bjl2l3xb6";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/windows/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
  };
}
