{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-joNYxKBcME8fzPf/lvA25yQ6GJ6eQukIUZk8VYz+nuM=";
  };

  meta = {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    license = lib.licenses.mit;
  };
}
