{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, click
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click-option-group";
  version = "0.5.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w0692s8fabncpggpwl2d4dfqjjlmcia271rrb8hcz0r6nvw98ak";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "click_option_group"
  ];

  meta = with lib; {
    description = "Option groups missing in Click";
    longDescription = ''
      Option groups are convenient mechanism for logical structuring
      CLI, also it allows you to set the specific behavior and set the
      relationship among grouped options (mutually exclusive options
      for example). Moreover, argparse stdlib package contains this
      functionality out of the box.
    '';
    homepage = "https://github.com/click-contrib/click-option-group";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
