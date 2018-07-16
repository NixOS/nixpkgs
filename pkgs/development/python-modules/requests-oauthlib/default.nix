{ stdenv, buildPythonPackage, fetchPypi
, oauthlib, requests }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "requests-oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8886bfec5ad7afb391ed5443b1f697c6f4ae98d0e5620839d8b4499c032ada3f";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
