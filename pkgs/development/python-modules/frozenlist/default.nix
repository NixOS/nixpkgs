{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "frozenlist";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nOzS004uduS5C8y4ig0IaYyfk+h94uTiN048X66HO+Q=";
  };

  nativeBuildInputs = [
    cython
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=frozenlist" ""
  '';

  preBuild = ''
    cython frozenlist/_frozenlist.pyx
  '';

  pythonImportsCheck = [
    "frozenlist"
  ];

  meta = with lib; {
    description = "Python module for list-like structure";
    homepage = "https://github.com/aio-libs/frozenlist";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
