{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  cython,
  borgbackup,
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-python";
    tag = "v${version}";
    hash = "sha256-j1MpdnfG6tCgAFlza64erMhJm/MkSK2QnixNv7MrQes=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "msgpack" ];

  passthru.tests = {
    # borgbackup is sensible to msgpack versions: https://github.com/borgbackup/borg/issues/3753
    # please be mindful before bumping versions.
    inherit borgbackup;
  };

  preBuild = ''
    make cython
  '';

  meta = with lib; {
    description = "MessagePack serializer implementation";
    homepage = "https://github.com/msgpack/msgpack-python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/${src.tag}/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
