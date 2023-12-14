{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, pytestCheckHook
, flit-core }:

buildPythonPackage rec {
  pname = "pyluach";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kGOiU4fNdiQnb9BlZQi62giqim8i6Ns1KETNhY5pASs=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyluach" ];

  meta = with lib; {
    changelog = "https://github.com/simlist/pyluach/releases/tag/${version}";
    description =
      "A Python package for manipulating Hebrew (Jewish) calendar dates and Hebrew-Gregorian conversion.";
    homepage = "https://github.com/simlist/pyluach";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
