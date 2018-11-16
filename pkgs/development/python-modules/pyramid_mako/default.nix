{ stdenv
, buildPythonPackage
, fetchPypi
, webtest
, pyramid
, Mako
}:

buildPythonPackage rec {
  pname = "pyramid_mako";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00811djmsc4rz20kpy2paam05fbx6dmrv2i5jf90f6xp6zw4isy6";
  };

  buildInputs = [ webtest ];
  propagatedBuildInputs = [ pyramid Mako ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Pylons/pyramid_mako;
    description = "Mako template bindings for the Pyramid web framework";
    license = licenses.bsd0;
  };

}
