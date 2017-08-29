{ stdenv, buildPythonPackage, fetchPypi
, oauthlib, requests }:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "requests-oauthlib";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18gg9dwral153c10f8bwhz2dy4nw7c6mws5a2g7gidk3z5xhqy4n";
  };

  doCheck = false;        # Internet tests fail when building in chroot
  propagatedBuildInputs = [ oauthlib requests ];

  meta = with stdenv.lib; {
    description = "OAuthlib authentication support for Requests";
    homepage = https://github.com/requests/requests-oauthlib;
    maintainers = with maintainers; [ prikhi ];
  };
}
