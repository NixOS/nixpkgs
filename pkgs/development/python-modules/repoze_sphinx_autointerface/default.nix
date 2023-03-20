{ lib
, buildPythonPackage
, fetchPypi
, zope_interface
, sphinx
}:

buildPythonPackage rec {
  pname = "repoze.sphinx.autointerface";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SGvxQjpGlrkVPkiM750ybElv/Bbd6xSwyYh7RsYOKKE=";
  };

  propagatedBuildInputs = [ zope_interface sphinx ];

  meta = with lib; {
    homepage = "https://github.com/repoze/repoze.sphinx.autointerface";
    description = "Auto-generate Sphinx API docs from Zope interfaces";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
