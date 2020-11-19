{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, importlib-resources, pytest, xvfb_run }:

buildPythonPackage rec {
  pname = "pywebview";
  version = "3.3.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "r0x0r";
    repo = "pywebview";
    rev = version;
    sha256 = "015z7n0hdgkzn0p7aw1xsv6lwc260p8q67jx0zyd1zghnwyj8k79";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [ importlib-resources ];

  checkInputs = [ pytest xvfb_run ];

  checkPhase = ''
    pushd tests
    patchShebangs run.sh
    xvfb-run -s '-screen 0 800x600x24' ./run.sh
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/r0x0r/pywebview";
    description = "Lightweight cross-platform wrapper around a webview";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
  };
}
