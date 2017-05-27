{ stdenv, buildPythonPackage, fetchurl
, oauthlib, requests }:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "requests-oauthlib";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://github.com/requests/requests-oauthlib/archive/v${version}.tar.gz";
    sha256 = "0cdn45k7qla0qwha0rm9pk9bcfhghvmqrdsphs73irs2rzk5cp2j";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
