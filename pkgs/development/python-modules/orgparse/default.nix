{
  lib,
  setuptools-scm,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "orgparse";
  version = "0.4.20231004";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pOOK6tq/mYiw9npmrNCCedGCILy8QioSkGDCiQu6kaA=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pyproject = true;

  meta = with lib; {
    homepage = "https://github.com/karlicoss/orgparse";
    description = "orgparse - Emacs org-mode parser in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ twitchy0 ];
  };
}
