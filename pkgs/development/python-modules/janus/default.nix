{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, pytest-asyncio }:

buildPythonPackage rec {
  pname = "janus";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bc6a9b99f401978113937f477b30ef5a104897e92f6f831aa5b95b57d103eb1";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ pytest-asyncio pytestCheckHook ];

  # also fails upstream: https://github.com/aio-libs/janus/pull/258
  disabledTests = [ "test_format" ];

  meta = with lib; {
    description = "Mixed sync-async queue";
    homepage = "https://github.com/aio-libs/janus";
    license = licenses.asl20;
    maintainers = [ maintainers.simonchatts ];
  };
}
