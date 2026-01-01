{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ipmi";
<<<<<<< HEAD
  version = "0.5.8";
=======
  version = "0.5.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kontron";
    repo = "python-ipmi";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-9xPnLNyHKvVebRM/mIoEVzhT2EwmgJxCTztLSZrnXVc=";
=======
    hash = "sha256-vwjVUkTeVC1On1I1BtM0kBbne6CbX/6Os1+HA8WN9jU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=version," "version='${version}',"
  '';

  build-system = [ setuptools ];

<<<<<<< HEAD
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyipmi" ];

  meta = {
    description = "Python IPMI Library";
    homepage = "https://github.com/kontron/python-ipmi";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ipmitool.py";
=======
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyipmi" ];

  meta = with lib; {
    description = "Python IPMI Library";
    mainProgram = "ipmitool.py";
    homepage = "https://github.com/kontron/python-ipmi";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
