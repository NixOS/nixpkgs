{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bite-parser";
  version = "0.2.3";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    pname = "bite_parser";
    inherit version;
    hash = "sha256-5ZdmOhnxpBI4XGgT4n8JEriqOEkiUZ1Cc96/pyluhe4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bite" ];

  meta = {
    description = "Asynchronous parser taking incremental bites out of your byte input stream";
    homepage = "https://github.com/jgosmann/bite-parser";
    changelog = "https://github.com/jgosmann/bite-parser/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
