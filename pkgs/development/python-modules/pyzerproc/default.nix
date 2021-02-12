{ lib
, asynctest
, bleak
, click
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-cov
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyzerproc";
  version = "0.4.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "1qlxvvy9fyff56dvc46nsd5ngkxqhdi7s4gwfndj7dn76j81srpq";
  };

  # Remove pytest-runner, https://github.com/emlove/pyzerproc/pull/1
  patchPhase = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    bleak
    click
  ];

  checkInputs = [
    asynctest
    pytest-asyncio
    pytest-cov
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyzerproc" ];

  meta = with lib; {
    description = "Python library to control Zerproc Bluetooth LED smart string lights";
    homepage = "https://github.com/emlove/pyzerproc";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
