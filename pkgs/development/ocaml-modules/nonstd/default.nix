{ lib, fetchFromBitbucket, buildDunePackage }:

buildDunePackage rec {
  pname = "nonstd";
  version = "0.0.3";

  minimumOCamlVersion = "4.02";

  src = fetchFromBitbucket {
    owner = "smondet";
    repo = pname;
    rev = "${pname}.${version}";
    sha256 = "0ccjwcriwm8fv29ij1cnbc9win054kb6pfga3ygzdbjpjb778j46";
  };

  doCheck = true;

  meta = with lib; {
    homepage = https://bitbucket.org/smondet/nonstd;
    description = "Non-standard mini-library";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
