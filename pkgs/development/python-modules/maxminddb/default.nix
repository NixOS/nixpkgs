{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libmaxminddb,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "maxminddb";
  version = "2.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fYQtMuJiCryJS315paEAemnfLGzyeaBrlMnDkT9m8mQ=";
  };

  buildInputs = [ libmaxminddb ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "maxminddb" ];

  # The multiprocessing tests fail on Darwin because multiprocessing uses spawn instead of fork,
  # resulting in an exception when it can’t pickle the `lookup` local function.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "multiprocessing" ];

  meta = with lib; {
    description = "Reader for the MaxMind DB format";
    homepage = "https://github.com/maxmind/MaxMind-DB-Reader-python";
    changelog = "https://github.com/maxmind/MaxMind-DB-Reader-python/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
