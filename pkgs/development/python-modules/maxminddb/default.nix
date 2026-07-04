{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libmaxminddb,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "maxminddb";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l5KxliWUXf8Ubi4xh/nkcLgjMKkS986lWBuL1a8w2os=";
  };

  buildInputs = [ libmaxminddb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "maxminddb" ];

  # The multiprocessing tests fail on Darwin because multiprocessing uses spawn instead of fork,
  # resulting in an exception when it can’t pickle the `lookup` local function.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "multiprocessing" ];

  meta = {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
    changelog = "https://github.com/maxmind/MaxMind-DB-Reader-python/blob/v${version}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
