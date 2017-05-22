{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  name = "impacket-git-2017-05-09";

  src = fetchFromGitHub {
    owner = "CoreSecurity";
    repo = "impacket";
    rev = "61b8487be985ffc6c61950881a556a98eb533a3f";
    sha256 = "0093hx92as733d3g0n2hh5a5cmgyd811wl96x6cf5qcqgg43f2l9";
  };

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/CoreSecurity/impacket";
    license = "Apache modified";
    maintainers = with maintainers; [ fpletz ];
  };
}
