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

buildPythonPackage rec {
  pname = "pymarshal";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stargateaudio";
    repo = pname;
    rev = version;
    hash = "sha256-Ds8JV2mtLRcKXBvPs84Hdj3MxxqpeV5muKCSlAFCj1A=";
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

  pytestFlagsArray = [ "test" ];

  meta = {
    description = "Python data serialization library";
    homepage = "https://github.com/stargateaudio/pymarshal";
    maintainers = with lib.maintainers; [ yuu ];
    license = lib.licenses.bsd2;
  };
}
