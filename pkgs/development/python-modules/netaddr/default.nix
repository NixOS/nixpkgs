{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "netaddr";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-brj+3wQSxtKU0GiFwRDelFz00i0rUQ0EBPTgaVCFeYc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "netaddr"
  ];

  meta = with lib; {
    description = "A network address manipulation library for Python";
    mainProgram = "netaddr";
    homepage = "https://netaddr.readthedocs.io/";
    downloadPage = "https://github.com/netaddr/netaddr/releases";
    changelog = "https://github.com/netaddr/netaddr/blob/${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
