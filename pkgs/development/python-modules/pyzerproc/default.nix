{ lib
, bleak
, click
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyzerproc";
  version = "0.4.11";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FNiq/dbh5PMTxnKCKDSHEvllehAEUYvWZS+OyP3lSW8=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  propagatedBuildInputs = [
    bleak
    click
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyzerproc"
  ];

  meta = with lib; {
    description = "Python library to control Zerproc Bluetooth LED smart string lights";
    homepage = "https://github.com/emlove/pyzerproc";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
