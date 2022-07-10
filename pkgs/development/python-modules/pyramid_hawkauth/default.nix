{ stdenv
, lib
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

  pythonImportsCheck = [ "pyramid_hawkauth" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "https://github.com/mozilla-services/pyramid_hawkauth";
    description = "A Pyramid authentication plugin for HAWK";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
