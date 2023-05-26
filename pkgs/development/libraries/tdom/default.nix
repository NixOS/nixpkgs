{ lib, fetchfossil, tcl }:

tcl.mkTclDerivation {
  pname = "tdom";
  version = "0.9.3";

  src = fetchfossil {
    url = "http://tdom.org";
    rev = "3eb60c75dad1df56";
    sha256 = "sha256-3Odqzlo9wEpbSQceHNaeceb6OSWtueSxyWxmfc7T1AY=";
  };

  meta = with lib; {
    homepage = "https://tdom.org/";
    description = "An XML / DOM / XPath / XSLT / HTML / JSON implementation for Tcl";
    license = licenses.mpl20;
    platforms = tcl.meta.platforms;
    maintainers = with maintainers; [ nat-418 ];
  };
}
