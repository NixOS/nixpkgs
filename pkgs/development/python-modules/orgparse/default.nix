{
  lib,
  setuptools-scm,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "orgparse";
  version = "0.4.20250520";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZHL9Ft3Ku1I5GFBchlJjq/oFrIC1k+ZooInNopGxot4=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pyproject = true;

  meta = with lib; {
    homepage = "https://github.com/karlicoss/orgparse";
    description = "Orgparse - Emacs org-mode parser in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ twitchy0 ];
  };
}
