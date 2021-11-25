{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, pytest-asyncio }:

buildPythonPackage rec {
  pname = "janus";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "127edc891f9e13420dd12f230d5113fa3de7f93662b81acfaf845989edf5eebf";
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
