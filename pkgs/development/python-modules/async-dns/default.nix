{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  python,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "async-dns";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gera2ld";
    repo = "async_dns";
    tag = "v${version}";
    hash = "sha256-jjfJBqTGX+lM9lwNA4TKmlNC1efuCBUMPm3Gf3eHx24=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    # Test needs network access
    rm -r tests/resolver
    ${python.interpreter} -m unittest

    runHook postCheck
  '';

  pythonImportsCheck = [ "async_dns" ];

  meta = with lib; {
    description = "Python DNS library";
    homepage = "https://github.com/gera2ld/async_dns";
    changelog = "https://github.com/gera2ld/async_dns/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
