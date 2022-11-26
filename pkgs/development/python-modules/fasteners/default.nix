{ lib
, buildPythonPackage
, diskcache
, fetchFromGitHub
, more-itertools
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "fasteners";
  version = "0.17.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "harlowja";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FVhHp8BZ/wQQyr5AcuDo94LlflixhjZ0SnheSdHuDVQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    diskcache
    more-itertools
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Module that provides useful locks";
    homepage = "https://github.com/harlowja/fasteners";
    changelog = "https://github.com/harlowja/fasteners/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
