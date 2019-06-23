{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-tables2";
  version = "2.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bm022gbm3l4ngamjb6icg25047js64yar3mpdwpn59sc038c0wq";
  };

  propagatedBuildInputs = [ django ];

  # test files not included in package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An app for creating HTML tables";
    homepage = "https://django-tables2.readthedocs.io/en/latest/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gerschtli ];
  };
}
