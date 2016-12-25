{
stdenv, pkgs, python, wrapPython, buildPythonPackage,
flask, pytz, six, aniso8601, itsdangerous, click, jinja2, werkzeug, dateutil, nose
}:

buildPythonPackage rec {
  pname = "Flask-RESTful";
  name = "${pname}-${version}";
  version = "0.3.5";
  src = pkgs.fetchurl {
    url = "mirror://pypi/F/${pname}/${name}.tar.gz";
    sha256 = "0hjcmdb56b7z4bkw848lxfkyrpnkwzmqn2dgnlv12mwvjpzsxr6c";
  };
  PYTHON_EGG_CACHE = "`pwd`/.egg-cache";
  meta = with stdenv.lib; {
    description = "Simple framework for creating REST APIs";
    homepage    = "https://github.com/flask-restful/flask-restful/";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
  };
  propagatedBuildInputs = [ flask pytz six aniso8601 itsdangerous click jinja2 werkzeug dateutil nose ];
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
