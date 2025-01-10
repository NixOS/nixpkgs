{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  coloredlogs,
  humanfriendly,
  property-manager,
  fasteners,
  six,
  pytestCheckHook,
  mock,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "executor";
  version = "23.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-executor";
    rev = version;
    sha256 = "1mr0662c5l5zx0wjapcprp8p2xawfd0im3616df5sgv79fqzwfqs";
  };

  propagatedBuildInputs = [
    coloredlogs
    humanfriendly
    property-manager
    fasteners
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    virtualenv
  ];

  # ignore impure tests
  disabledTests = [
    "option"
    "retry"
    "remote"
    "ssh"
    "foreach"
    "local_context"
    "release" # meant to be ran on ubuntu to succeed
  ];

  meta = with lib; {
    changelog = "https://github.com/xolox/python-executor/blob/${version}/CHANGELOG.rst";
    description = "Programmer friendly subprocess wrapper";
    mainProgram = "executor";
    homepage = "https://github.com/xolox/python-executor";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
