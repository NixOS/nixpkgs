{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, setuptools-scm
, pydantic
, typeguard
, mock
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygls";
  version = "0.11.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "openlawlibrary";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/nmDaA67XzrrmfwlBm5syTS4hn25m30Zb3gvOdL+bR8=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;
  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    pydantic
    typeguard
  ];
  # We don't know why an early version of pydantic is required, see:
  # https://github.com/openlawlibrary/pygls/issues/221
  preBuild = ''
    substituteInPlace setup.cfg \
      --replace "pydantic>=1.7,<1.9" "pydantic"
  '';

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # Fixes hanging tests on Darwin
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pygls" ];

  meta = with lib; {
    description = "Pythonic generic implementation of the Language Server Protocol";
    homepage = "https://github.com/openlawlibrary/pygls";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
