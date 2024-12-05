{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  pillow,
}:

buildPythonPackage rec {
  pname = "icnsutil";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "relikd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tiq8h6s2noWLBIOIWcj8jfSqJFN01ee2uoHN4aFwn7s=";
  };

  dependencies = [ pillow ];

  checkPhase = ''
    ${python.interpreter} tests/test_icnsutil.py
    ${python.interpreter} tests/test_cli.py
  '';

  pythonImportsCheck = [ "icnsutil" ];

  meta = with lib; {
    description = "Create and extract .icns files";
    homepage = "https://github.com/relikd/icnsutil";
    changelog = "https://github.com/relikd/icnsutil/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ reckenrode ];
  };
}
