{ lib
, asynctest
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
  version = "0.4.8";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emlove";
    repo = pname;
    rev = version;
    sha256 = "sha256-PNvkgjPcBbnETjWpVF3De9O9IprdpCke0nWvJ9Tju1M=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  propagatedBuildInputs = [
    bleak
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.8") [
    asynctest
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
