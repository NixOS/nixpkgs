{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dllist";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WardBrian";
    repo = "dllist";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCAxL7jfF3ty+3PwOFQgXCXmRWDcXZ9sXUJg0EmTEGI=";
  };

  postPatch = ''
    # test_euler expects the test extension's path to contain /dllist/, the name of upstream's checkout.
    substituteInPlace test/test_linux.py test/test_macos.py \
      --replace-fail '"/dllist/test/test_éxt/' '"/test/test_éxt/'

    # distutils was removed from the standard library in Python 3.12.
    substituteInPlace "test/test_éxt/setup.py" \
      --replace-fail "from distutils.core import" "from setuptools import"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # test_euler loads the test extension in test/test_éxt (the é tests a non-ASCII path) and checks that dllist then
  # lists it; it skips itself if it can't import the extension. Build it in place, as upstream's CI does with
  # `pip install -e`.
  preCheck = ''
    pushd "test/test_éxt"
    python setup.py build_ext --inplace
    popd
    export PYTHONPATH="$PWD/test/test_éxt:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "dllist" ];

  meta = {
    description = "List the shared libraries loaded by the current process";
    homepage = "https://github.com/WardBrian/dllist";
    changelog = "https://github.com/WardBrian/dllist/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ connorbaker ];
  };
})
