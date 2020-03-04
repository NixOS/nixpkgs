{ stdenv, buildPythonPackage, fetchPypi
, oauthlib, requests }:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "requests-oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0smaxs5ixng4z0k6dsgmm6s972ka3p6a2ykdpnl23mqzlw0ic9ml";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
