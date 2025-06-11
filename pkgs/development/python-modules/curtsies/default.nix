{
  lib,
  stdenv,
  blessed,
  buildPythonPackage,
  cwcwidth,
  fetchPypi,
  pyte,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "curtsies";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-br4zIVvXyShRpQYEnHIMykz1wZLBZlwdepigTEcCdg4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    blessed
    cwcwidth
  ];

  nativeCheckInputs = [
    pyte
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
    changelog = "https://github.com/bpython/curtsies/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
