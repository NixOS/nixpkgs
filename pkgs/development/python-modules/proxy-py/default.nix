{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, openssl
, paramiko
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "proxy-py";
  version = "2.4.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "abhinavsingh";
    repo = "proxy.py";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-dA7a9RicBFCSf6IoGX/CdvI8x/xMOFfNtyuvFn9YmHI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    paramiko
    typing-extensions
  ];

  checkInputs = [
    openssl
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "typing-extensions==3.7.4.3" "typing-extensions"
  '';

  pythonImportsCheck = [
    "proxy"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Python proxy framework";
    homepage = "https://github.com/abhinavsingh/proxy.py";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
