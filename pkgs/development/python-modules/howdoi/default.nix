{
  lib,
  appdirs,
  buildPythonPackage,
  cachelib,
  colorama,
  cssselect,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Bad test case fix: comparing hardcoded string to internet search result
    # PR merged: https://github.com/gleitz/howdoi/pull/497
    # Please remove on the next release
    (fetchpatch {
      url = "https://github.com/gleitz/howdoi/commit/7d24e9e1c87811a6e66d60f504381383cf1ac3fd.patch";
      sha256 = "sha256-AFQMnMEijaExqiimbNaVeIRmZJ4Yj0nGUOEjfsvBLh8=";
    })
  ];

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
    changelog = "https://github.com/gleitz/howdoi/blob/v${version}/CHANGES.txt";
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    license = licenses.mit;
    maintainers = [ ];
  };
}
