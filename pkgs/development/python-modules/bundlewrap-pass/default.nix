{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bundlewrap,
  pass,
}:

buildPythonPackage rec {
  pname = "bundlewrap-pass";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3KmUTTOQ46TiKXNkKLRweMEe5m/zJ1gvAVJttJBdzik=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bundlewrap
    pass
  ];

  # upstream has no checks
  doCheck = false;

  pythonImportsCheck = [ "bwpass" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/bundlewrap-pass";
    description = "Use secrets from pass in your BundleWrap repo";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
