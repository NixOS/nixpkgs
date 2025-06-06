{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  protobuf,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "1.3.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "biliass";
    rev = "refs/tags/v${version}";
    hash = "sha256-hBorYAqtxTZ4LElxxJOGxC2g7sBRhRKVv6HOVHZn9FA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ protobuf ];

  doCheck = false; # test artifacts missing

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "biliass" ];

  meta = with lib; {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    mainProgram = "biliass";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
