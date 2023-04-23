{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, nose
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-ipmi";
  version = "0.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kontron";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-IXEq3d1nXGEndciQw2MJ1Abc0vmEYez+k6aWGSWEzWA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version," "version='${version}',"
  '';

  propagatedBuildInputs = [
    future
  ];

  nativeCheckInputs = [
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyipmi"
  ];

  meta = with lib; {
    description = "Python IPMI Library";
    homepage = "https://github.com/kontron/python-ipmi";
    license = with licenses; [ lgpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
