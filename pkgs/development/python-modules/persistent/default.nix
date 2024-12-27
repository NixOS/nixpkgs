{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,

  # build-systems
  setuptools,

  # dependencies
  cffi,
  zope-deferredimport,
  zope-interface,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qhfm5ISXONCAcG6+bHnsjbD0qyyHl1+bNCSer3qWWGc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-deferredimport
  ] ++ lib.optionals (!isPyPy) [ cffi ];

  pythonImportsCheck = [ "persistent" ];

  meta = with lib; {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    changelog = "https://github.com/zopefoundation/persistent/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
