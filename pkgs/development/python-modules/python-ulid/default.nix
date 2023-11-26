{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, freezegun
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-ulid";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mdomke";
    repo = "python-ulid";
    rev = "refs/tags/${version}";
    hash = "sha256-d5jCPxWUOfw/OCtbA9Db9+s1D5DAdL+vbPR8zavgbbo=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ulid" ];

  meta = with lib; {
    description = "ULID implementation for Python";
    homepage = "https://github.com/mdomke/python-ulid";
    changelog = "https://github.com/mdomke/python-ulid/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
