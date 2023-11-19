{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, colorama
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-resource-path";
  version = "1.3.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "yukihiko-shinoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "1siv3pk4fsabz254fdzr7c0pxy124habnbw4ym66pfk883fr96g2";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    colorama
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_resource_path"
  ];

  meta = with lib; {
    description = "Pytest plugin to provide path for uniform access to test resources";
    homepage = "https://github.com/yukihiko-shinoda/pytest-resource-path";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
