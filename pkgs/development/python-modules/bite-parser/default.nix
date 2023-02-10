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
  version = "0.2.2";

  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    pname = "bite_parser";
    inherit version;
    hash = "sha256-mBghKgrNv4ZaRNowo7csWekmqrI0xAVKJKowSeumr4g=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
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
