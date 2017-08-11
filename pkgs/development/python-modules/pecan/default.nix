{ stdenv
, fetchPypi
, buildPythonPackage
# Python deps
, singledispatch
, logutils
, webtest
, Mako
, genshi
, Kajiki
, sqlalchemy
, gunicorn
, jinja2
, virtualenv
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pecan";
  version = "1.2.1";

  patches = [
    ./python36_test_fix.patch
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ikc32rd2hr8j2jxc0mllvdjvxydx3fwfp3z8sdxmkzdkixlb5cd";
  };

  propagatedBuildInputs = [ singledispatch logutils ];
  buildInputs = [
    webtest Mako genshi Kajiki sqlalchemy gunicorn jinja2 virtualenv
  ];

  meta = with stdenv.lib; {
    description = "Pecan";
    homepage = "http://github.com/pecan/pecan";
  };
}
