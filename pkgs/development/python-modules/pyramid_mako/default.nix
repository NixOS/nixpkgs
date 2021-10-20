{ lib
, buildPythonPackage
, fetchPypi
, webtest
, pyramid
, Mako
}:

buildPythonPackage rec {
  pname = "pyramid_mako";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0066c863441f1c3ddea60cee1ccc50d00a91a317a8052ca44131da1a12a840e2";
  };

  buildInputs = [ webtest ];
  propagatedBuildInputs = [ pyramid Mako ];

  meta = with lib; {
    homepage = "https://github.com/Pylons/pyramid_mako";
    description = "Mako template bindings for the Pyramid web framework";
    license = licenses.bsd0;
    maintainers = with maintainers; [];
    # broken on pyramid>=2.0
    # https://github.com/Pylons/pyramid_mako/issues/53
    broken = true;
  };
}
