{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tidyp";
  version = "1.04";

  src = fetchFromGitHub {
    owner = "petdance";
    repo = "tidyp";
    rev = version;
    sha256 = "0jslskziwzk4hb6i640fvpnbv2zxrvim6pdx2gwx5wyc64aviskc";
  };

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "A program that can validate your HTML, as well as modify it to be more clean and standard";
    homepage = "http://tidyp.com/";
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
    license = licenses.bsd3;
  };
}
