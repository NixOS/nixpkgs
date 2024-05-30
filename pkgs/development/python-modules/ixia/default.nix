{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "ixia";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "ixia";
    rev = "refs/tags/${version}";
    hash = "sha256-JGTwctzswItAJsKZzVVl+B2fZnCWpMmq9TnNgYY2Kng=";
  };

  build-system = [ poetry-core ];
  pythonImportsCheck = [ "ixia" ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/ixia/blob/${src.rev}/CHANGELOG.md";
    description = "Connecting secrets' security with random's versatility";
    license = licenses.mit;
    homepage = "https://trag1c.github.io/ixia";
    maintainers = with maintainers; [ sigmanificient ];
  };
}
