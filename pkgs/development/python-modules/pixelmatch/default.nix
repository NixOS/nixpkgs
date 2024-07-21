{
  lib,
  buildPythonPackage,
  fetchgit,
  pillow,
  poetry-core,
  pytest-benchmark,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pixelmatch";
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # Test fixtures are stored in LFS
  src = fetchgit {
    url = "https://github.com/whtsky/pixelmatch-py";
    rev = "v${version}";
    hash = "sha256-/zRQhwz+HjT0Hs4CunsqHxHWEtoIH9qMBowRb0Pps6Y=";
    fetchLFS = true;
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pillow
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlagsArray = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "pixelmatch" ];

  meta = with lib; {
    description = "Pixel-level image comparison library";
    homepage = "https://github.com/whtsky/pixelmatch-py";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
