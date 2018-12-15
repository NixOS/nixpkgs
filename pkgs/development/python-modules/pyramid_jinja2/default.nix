{ stdenv
, buildPythonPackage
, fetchPypi
, webtest
, jinja2
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_jinja2";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93c86e3103b454301f4d66640191aba047f2ab85ba75647aa18667b7448396bd";
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
