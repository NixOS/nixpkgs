{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bson,
  pytestCheckHook,
  pytest-cov-stub,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymarshal";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stargateaudio";
    repo = "pymarshal";
    rev = finalAttrs.version;
    hash = "sha256-o+eWa3XFDFn+fyVxWOI9LbKqBUVsYR8O7J4sFbSGvEg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'" ""
  '';

  build-system = [ setuptools ];

  dependencies = [ bson ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    bson
    pyyaml
  ];

  enabledTestPaths = [ "test" ];

  meta = {
    description = "Python data serialization library";
    homepage = "https://github.com/stargateaudio/pymarshal";
    maintainers = [ ];
    license = lib.licenses.bsd2;
  };
})
