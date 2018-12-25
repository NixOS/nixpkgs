{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pyramid
, simplejson
, konfig
}:

buildPythonPackage rec {
  pname = "mozsvc";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "mozservices";
    rev = version;
    sha256 = "0a0558g8j55pd1nnhnnf3k377jv6cah8lxb24v98rq8kxr5960cg";
  };

  doCheck = false; # lazy packager
  propagatedBuildInputs = [ pyramid simplejson konfig ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla-services/mozservices";
    description = "Various utilities for Mozilla apps";
    license = licenses.mpl20;
  };

}
