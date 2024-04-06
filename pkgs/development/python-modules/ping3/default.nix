{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "4.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uO2ObCZvizdGSrobagC6GDh116z5q5yIH9P8PcvpCi8=";
  };

  build-system = [ setuptools ];

  # Tests require additional permissions
  doCheck = false;

  pythonImportsCheck = [ "ping3" ];

  meta = with lib; {
    description = "ICMP ping implementation using raw socket";
    homepage = "https://github.com/kyan001/ping3";
    changelog = "https://github.com/kyan001/ping3/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "ping3";
  };
}
