{
  stdenv,
  lib,
  appdirs,
  buildPythonPackage,
  cachelib,
  colorama,
  cssselect,
  fetchFromGitHub,
  keep,
  lxml,
  pygments,
  pyquery,
  requests,
  rich,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u0k+h7Sp2t/JUnfPqRzDpEA+vNXB7CpyZ/SRvk+B9t0=";
  };

  propagatedBuildInputs = [
    appdirs
    cachelib
    colorama
    cssselect
    keep
    lxml
    pygments
    pyquery
    requests
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [ "test_colorize" ];

  pythonImportsCheck = [ "howdoi" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    changelog = "https://github.com/gleitz/howdoi/blob/v${version}/CHANGES.txt";
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
