{ lib
, buildPythonPackage
, fetchPypi

, pythonOlder

, pytestCheckHook

, setuptools
}:

buildPythonPackage rec {
  pname = "ago";
  version = "0.0.95";
  pyproject = true;

  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0gEPXqw99UTsSOwRYQLgaFkaNFsaWA8ylz24pQX8p0Q=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ago" ];

  meta = with lib; {
    description = "Human Readable Time Deltas";
    homepage = "https://git.unturf.com/python/ago";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vizid ];
  };
}
