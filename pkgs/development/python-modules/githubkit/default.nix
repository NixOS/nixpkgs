{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, httpx
, pydantic
, typing-extensions
}:

buildPythonPackage rec {
  pname = "githubkit";
  version = "0.10.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sKikL+761mBP7j+qugHKDQ0hVXT51FV8FYbB3ZJtweA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "githubkit" ];

  meta = {
    description = "GitHub SDK for Python";
    homepage = "https://github.com/yanyongyu/githubkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
  };
}
