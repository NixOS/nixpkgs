{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  webtest,
  pyramid,
  mako,
}:

buildPythonPackage rec {
  pname = "pyramid-mako";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0066c863441f1c3ddea60cee1ccc50d00a91a317a8052ca44131da1a12a840e2";
  };

  patches = [
    # Fix tests with pyramid >= 2.0
    # https://github.com/Pylons/pyramid_mako/pull/54
    (fetchpatch {
      url = "https://github.com/Pylons/pyramid_mako/commit/c0f9e7e0146a7f94e35a9401b1519ac8b7765f5b.patch";
      sha256 = "15swfm0a07bdl32s85426rmjh72jwfasjcrl849ppg035z75q9fx";
    })
  ];

  buildInputs = [ webtest ];
  propagatedBuildInputs = [
    pyramid
    mako
  ];

  meta = with lib; {
    homepage = "https://github.com/Pylons/pyramid_mako";
    description = "Mako template bindings for the Pyramid web framework";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
