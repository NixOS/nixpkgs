{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder, pytest-asyncio
, typing-extensions
}:

buildPythonPackage rec {
  pname = "janus";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df976f2cdcfb034b147a2d51edfc34ff6bfb12d4e2643d3ad0e10de058cb1612";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [ pytest-asyncio pytestCheckHook ];

  # also fails upstream: https://github.com/aio-libs/janus/pull/258
  disabledTests = [ "test_format" ];

  meta = with lib; {
    description = "Mixed sync-async queue";
    homepage = "https://github.com/aio-libs/janus";
    license = licenses.asl20;
    maintainers = [ maintainers.simonchatts ];
  };
}
