{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyheos";
  version = "0.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pyheos";
    rev = version;
    sha256 = "0rgzg7lnqzzqrjp73c1hj1hq8p0j0msyih3yr4wa2rj81s8ihmby";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests =
    [
      # accesses network
      "test_connect_timeout"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # stuck in epoll
      "test_disconnect"
      "test_commands_fail_when_disconnected"
    ];

  pythonImportsCheck = [ "pyheos" ];

  meta = with lib; {
    description = "Async python library for controlling HEOS devices through the HEOS CLI Protocol";
    homepage = "https://github.com/andrewsayre/pyheos";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
