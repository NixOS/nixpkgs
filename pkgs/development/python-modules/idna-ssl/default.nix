{ lib, buildPythonPackage, fetchFromGitHub, idna }:

buildPythonPackage rec {
  pname = "idna-ssl";
  version = "1.1.0";

  src = fetchFromGitHub {
     owner = "aio-libs";
     repo = "idna-ssl";
     rev = "v1.1.0";
     sha256 = "1jqwpv769np7zkwrpfivj82in7x84101w6s9v340ajw80bdqlaqv";
  };

  propagatedBuildInputs = [ idna ];

  # Infinite recursion: tests require aiohttp, aiohttp requires idna-ssl
  doCheck = false;

  meta = with lib; {
    description = "Patch ssl.match_hostname for Unicode(idna) domains support";
    homepage = "https://github.com/aio-libs/idna-ssl";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
