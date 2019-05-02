{ stdenv
, buildPythonPackage
, fetchPypi
, webtest
, pyramid
, Mako
}:

buildPythonPackage rec {
  pname = "pyramid_mako";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6da0987b9874cf53e72139624665a73965bbd7fbde504d1753e4231ce916f3a1";
  };

  buildInputs = [ webtest ];
  propagatedBuildInputs = [ pyramid Mako ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Pylons/pyramid_mako;
    description = "Mako template bindings for the Pyramid web framework";
    license = licenses.bsd0;
  };

}
