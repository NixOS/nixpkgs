{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pyramid
, hawkauthlib
, tokenlib
, webtest
}:

buildPythonPackage rec {
  pname = "pyramid_hawkauth";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "038ign7qlavlmvrhb2y8bygbxvy4j7bx2k1zg0i3wblg2ja50w7h";
  };

  propagatedBuildInputs = [ pyramid hawkauthlib tokenlib ];
  buildInputs = [ webtest ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla-services/pyramid_hawkauth";
    description = "A Pyramid authentication plugin for HAWK";
    license = licenses.mpl20;
  };

}
