{ lib
, boto3
, buildPythonPackage
, fetchPypi
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "mypy-boto3-s3";
  version = "1.18.56";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61c74253cb77a0734970703d58a49e29624cec76d97da31fa912faf6f6d3347b";
  };

  propagatedBuildInputs = [
    boto3
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mypy_boto3_s3" ];

  meta = with lib; {
    description = "Type annotations for boto3";
    homepage = "https://vemel.github.io/boto3_stubs_docs/mypy_boto3_s3/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
