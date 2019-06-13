{ stdenv
, buildPythonPackage
, fetchPypi
, webtest
, jinja2
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_jinja2";
  version = "2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81e0615cb3108f2a251ff3141ad0d698a5d03685819f3a836ea84787e8489502";
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
