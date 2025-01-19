{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-LH9+3MLme4UIcpm5o/apNmkbmJ6NsRsW5TkGpmiNHP0=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/windows/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
  };
}
