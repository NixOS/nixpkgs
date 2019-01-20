{ stdenv
, buildPythonPackage
, fetchPypi
, webtest
, jinja2
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_jinja2";
  version = "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c21081f65a5bec0b76957990c2b89ed41f4fd11257121387110cb722fd0e5eb";
  };

  buildInputs = [ webtest ];
  propagatedBuildInputs = [ jinja2 pyramid ];

  meta = with stdenv.lib; {
    description = "Jinja2 template bindings for the Pyramid web framework";
    homepage = https://github.com/Pylons/pyramid_jinja2;
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };

}
