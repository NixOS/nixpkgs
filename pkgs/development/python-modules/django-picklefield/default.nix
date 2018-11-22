{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-picklefield";
  version = "1.1.0";

  meta = {
    description = "A pickled object field for Django";
    homepage = https://github.com/gintas/django-picklefield;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "174zlsajpjflrf3jgn0wp5svnxfyrjadk4s9jb45vzjqcmffwzyf";
  };
}
