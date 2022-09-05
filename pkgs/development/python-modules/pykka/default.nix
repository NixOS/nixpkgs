{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "3.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-bvRjFpXufGygTgPfEOJOCXFbMy3dNlrTHlGoaIG/Fbs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "A Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/blob/v${version}/docs/changes.rst";
    maintainers = with maintainers; [ marsam ];
    license = licenses.asl20;
  };
}
