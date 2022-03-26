{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, passlib
, dnspython
, loguru
, toml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ciscoconfparse";
  version = "1.6.36";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = pname;
    rev = version;
    sha256 = "sha256-nIuuqAxz8eHEQRuH8nfYVQ+vGMmcDcARJLizoI5Mty8=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    passlib
    dnspython
    loguru
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/parse_test.py"
  ];

  disabledTests = [
    "test_dns_lookup"
    "test_reverse_dns_lookup"
  ];

  pythonImportsCheck = [ "ciscoconfparse" ];

  meta = with lib; {
    description =
      "Parse, Audit, Query, Build, and Modify Cisco IOS-style configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.astro ];
  };
}
