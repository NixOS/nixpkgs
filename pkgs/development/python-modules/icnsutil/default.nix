{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pillow,
}:

buildPythonPackage rec {
  pname = "icnsutil";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "relikd";
    repo = "icnsutil";
    tag = "v${version}";
    hash = "sha256-tiq8h6s2noWLBIOIWcj8jfSqJFN01ee2uoHN4aFwn7s=";
  };

  dependencies = [ pillow ];

  checkPhase = ''
    ${python.interpreter} tests/test_icnsutil.py
    ${python.interpreter} tests/test_cli.py
  '';

  pythonImportsCheck = [ "icnsutil" ];

  meta = {
    description = "Create and extract .icns files";
    homepage = "https://github.com/relikd/icnsutil";
    changelog = "https://github.com/relikd/icnsutil/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ reckenrode ];
  };
}
