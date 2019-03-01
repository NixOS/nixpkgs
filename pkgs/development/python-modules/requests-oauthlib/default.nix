{ stdenv, buildPythonPackage, fetchPypi
, oauthlib, requests }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "requests-oauthlib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd6533330e8748e94bf0b214775fed487d309b8b8fe823dc45641ebcd9a32f57";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
