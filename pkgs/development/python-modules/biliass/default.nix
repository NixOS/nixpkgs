{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, protobuf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "1.3.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "biliass";
    rev = "refs/tags/v${version}";
    hash = "sha256-Opb4rlGe+LDJZs3F7e/NZYfuMtHEWUZeMm8VZQfEzKI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  doCheck = false; # test artifacts missing

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "biliass"
  ];

  meta = with lib; {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
