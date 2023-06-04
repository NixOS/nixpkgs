{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, protobuf
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "protoc-gen-swagger";
  version = "b572618d0aadcef63224bf85ebba05270b573a53";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "universe-proton";
    repo = pname;
    rev = version;
    hash = "sha256-ooY0W+bgkmrI4lvqile4/4016LJsx5c6gc4rnVmNtVU=";
  };

  propagatedBuildInputs = [
    setuptools
    protobuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "protoc_gen_swagger"
  ];

  meta = with lib; {
    description = "A python package for swagger annotation proto files";
    homepage = "https://github.com/universe-proton/protoc-gen-swagger";
    license = licenses.asl20;
    maintainers = with maintainers; [ humancalico ];
  };
}
