{ stdenv, buildPythonPackage, fetchPypi
, oauthlib, requests }:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "requests-oauthlib";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s7lh5q661gjza1czlmibkrwf8dcj9qfqm3hs39sdbbyflbc8fl8";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
