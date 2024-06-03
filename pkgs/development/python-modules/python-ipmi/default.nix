{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ipmi";
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kontron";
    repo = "python-ipmi";
    rev = "refs/tags/${version}";
    hash = "sha256-G5FcFHtyN8bXMjj/yfJgzcfmV1mxQ9lu3GM3XMeTWVU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version," "version='${version}',"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyipmi" ];

  meta = with lib; {
    description = "Python IPMI Library";
    mainProgram = "ipmitool.py";
    homepage = "https://github.com/kontron/python-ipmi";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
