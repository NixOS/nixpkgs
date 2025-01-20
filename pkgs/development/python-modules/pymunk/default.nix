{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
  cffi,
  pytestCheckHook,
  pythonOlder,
  ApplicationServices,
}:

buildPythonPackage rec {
  pname = "pymunk";
  version = "6.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OsbnC5goH/6AINeu+VBBjPOBG5BNOhHFRVz02G7M95Y=";
  };

  nativeBuildInputs = [ cffi ];

  build-system = [ setuptools ];

  dependencies = [ cffi ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ ApplicationServices ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext --inplace
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "pymunk/tests" ];

  pythonImportsCheck = [ "pymunk" ];

  meta = with lib; {
    description = "2d physics library";
    homepage = "https://www.pymunk.org";
    changelog = "https://github.com/viblo/pymunk/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
