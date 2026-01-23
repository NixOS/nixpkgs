{
  lib,
  buildPythonPackage,
  fetchPypi,
  easyprocess,
  path,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/At/57IazatHpYWrlAfKflxPlstoiFddtrDOuR8OEFo=";
  };

  nativeCheckInputs = [
    easyprocess
    path
    pytestCheckHook
  ];

  pythonImportsCheck = [ "entrypoint2" ];

  meta = {
    description = "Easy to use command-line interface for python modules";
    homepage = "https://github.com/ponty/entrypoint2/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ austinbutler ];
  };
}
