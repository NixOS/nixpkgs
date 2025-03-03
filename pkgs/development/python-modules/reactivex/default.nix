{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "reactivex";
  version = "4.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "RxPY";
    rev = "refs/tags/v${version}";
    hash = "sha256-W1qYNbYV6Roz1GJtP/vpoPD6KigWaaQOWe1R5DZHlUw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for their GitHub releases
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  pythonImportsCheck = [ "reactivex" ];

  meta = with lib; {
    description = "Library for composing asynchronous and event-based programs";
    homepage = "https://github.com/ReactiveX/RxPY";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
