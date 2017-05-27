{ stdenv, buildPythonPackage, fetchurl
, oauthlib, requests }:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "requests-oauthlib";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://github.com/requests/requests-oauthlib/archive/v${version}.tar.gz";
    sha256 = "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
