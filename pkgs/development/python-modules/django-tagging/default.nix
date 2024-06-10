{
  buildPythonPackage,
  fetchPypi,
  django,
}:

buildPythonPackage rec {
  pname = "django-tagging";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28d68fa4831705e51ad7d1e845ed6dd9e354f9b6f8a5f63b655a430646ef4e8d";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = {
    description = "Generic tagging application for Django projects";
    homepage = "https://github.com/Fantomas42/django-tagging";
  };
}
