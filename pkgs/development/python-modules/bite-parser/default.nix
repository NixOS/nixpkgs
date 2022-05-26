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
  version = "0.1.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8021100bfbd6cc6056605361e763a3591efdea38014b3d8aa76c74c74de4ead4";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = "^3.7,<=3.10"' 'python = "^3.7,<3.11"' \
      --replace poetry.masonry.api poetry.core.masonry.api
  '';

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
