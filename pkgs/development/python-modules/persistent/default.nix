{
  lib,
  buildPythonPackage,
  cffi,
  fetchPypi,
  zope-interface,
  sphinx,
  manuel,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "persistent";
  version = "5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2+pdH/nbTkUco5vAtCqepTfmyskoKujAeA+4/64+yDQ=";
  };

  nativeBuildInputs = [
    sphinx
    manuel
  ];

  propagatedBuildInputs = [
    zope-interface
    cffi
  ];

  pythonImportsCheck = [ "persistent" ];

  meta = with lib; {
    description = "Automatic persistence for Python objects";
    homepage = "https://github.com/zopefoundation/persistent/";
    changelog = "https://github.com/zopefoundation/persistent/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ ];
  };
}
