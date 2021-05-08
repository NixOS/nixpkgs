{ lib
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytestCheckHook
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z6r3n78bilfzkbxj083p0ib04ia1bhfgnj2qq9x6q4mmykapqm1";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin-wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nand0p ];
  };
}
