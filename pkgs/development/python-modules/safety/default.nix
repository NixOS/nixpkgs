{ lib, buildPythonPackage, fetchPypi, requests, dparse, click, setuptools, pytestCheckHook }:

buildPythonPackage rec {
  pname = "safety";
  version = "1.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MOOU0CogrEm39lKS0Z04+pJ6j5WCzf060a27xmxkGtU=";
  };

  propagatedBuildInputs = [ requests dparse click setuptools ];

  # Disable tests depending on online services
  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    "test_check_live"
    "test_check_live_cached"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description =
      "Safety checks your installed dependencies for known security vulnerabilities";
    homepage = "https://github.com/pyupio/safety";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
