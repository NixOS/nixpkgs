{ lib, buildPythonPackage, fetchPypi, EasyProcess, path, pytestCheckHook }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/At/57IazatHpYWrlAfKflxPlstoiFddtrDOuR8OEFo=";
  };

  pythonImportsCheck = [ "entrypoint2" ];

  checkInputs = [ EasyProcess path pytestCheckHook ];

  meta = with lib; {
    description = "Easy to use command-line interface for python modules";
    homepage = "https://github.com/ponty/entrypoint2/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ austinbutler ];
  };
}
