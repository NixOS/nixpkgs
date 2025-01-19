{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  pytest-asyncio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "janus";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CXDzjg5yVABJbINKNopn7lUdw7WtCiV+Ey9bRvLnd3A=";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # also fails upstream: https://github.com/aio-libs/janus/pull/258
  disabledTests = [ "test_format" ];

  meta = with lib; {
    description = "Mixed sync-async queue";
    homepage = "https://github.com/aio-libs/janus";
    license = licenses.asl20;
    maintainers = [ maintainers.simonchatts ];
  };
}
