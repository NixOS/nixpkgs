{ lib
, buildPythonPackage
, fetchFromGitHub
, smartmontools
, humanfriendly
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmart";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-SMART";
    rev = "refs/tags/v${version}";
    hash = "sha256-qZJwUxU9LSKXpftBuKFnxI4gygHIuJEwGJqFaBlCudc=";
  };

  postPatch = ''
    substituteInPlace pySMART/utils.py \
      --replace "which('smartctl')" '"${smartmontools}/bin/smartctl"'
  '';

  propagatedBuildInputs = [
    humanfriendly
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pySMART"
  ];

  meta = with lib; {
    description = "Wrapper for smartctl (smartmontools)";
    homepage = "https://github.com/truenas/py-SMART";
    changelog = "https://github.com/truenas/py-SMART/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
