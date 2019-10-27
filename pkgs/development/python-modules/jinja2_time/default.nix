{ stdenv
, buildPythonPackage
, fetchPypi
, arrow
, jinja2
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "jinja2-time";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0dr7cfpjnjj8bgl2vk9063a53649pn37wnlkd8hxjy656slkni";
  };

  propagatedBuildInputs = [ arrow jinja2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/hackebrot/jinja2-time;
    description = "Jinja2 Extension for Dates and Times";
    license = licenses.mit;
  };

}
