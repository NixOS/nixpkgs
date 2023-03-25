{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "ink-extensions";

  src = fetchFromGitHub {
    owner = "evil-mad";
    repo = "ink_extensions";
    rev = "v${version}";
    sha256 = "sha256-rv+aC8YW2EUrTExRBT2PTqDWMB4EuJqBav49oERB4vo=";
  };

  propagatedBuildInputs = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook mock ];
  pythonImportsCheck = [ "ink_extensions" ];

  disabledTests = [
    "test_init"
    "test_init_w_formatter"
  ];

  meta = with lib; {
    description = "Python dependencies for running Inkscape extensions outside of Inkscape";
    homepage = "https://github.com/evil-mad/ink_extensions";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sdedovic ];
  };
}
