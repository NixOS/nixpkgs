{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, pytest-asyncio
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "bite-parser";
  version = "0.1.3";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f246e98a5556d6ed9a33fda1e94c3ab906305729feb30d25e35344b3e1c1fd9";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    typing-extensions
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
