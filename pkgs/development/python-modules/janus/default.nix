{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, pytest-asyncio }:

buildPythonPackage rec {
  pname = "janus";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f10dcf5776e8d49cc30ec86d5eb7268eeec39abaa24fe0332ee8fb8fa3611845";
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
