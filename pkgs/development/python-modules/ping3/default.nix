{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "5.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bJm8hE4Lfbxcl2XotTAUDa8czSESyZ2wGreYMb2Agc0=";
  };

  build-system = [ setuptools ];

  # Tests require additional permissions
  doCheck = false;

  pythonImportsCheck = [ "ping3" ];

  meta = {
    description = "ICMP ping implementation using raw socket";
    homepage = "https://github.com/kyan001/ping3";
    changelog = "https://github.com/kyan001/ping3/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "ping3";
  };
}
