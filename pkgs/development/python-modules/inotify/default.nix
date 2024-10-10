{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "inotify";
  version = "unstable-2020-08-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "PyInotify";
    rev = "f77596ae965e47124f38d7bd6587365924dcd8f7";
    hash = "sha256-X0gu4s1R/Kg+tmf6s8SdZBab2HisJl4FxfdwKktubVc=";
  };

  postPatch = ''
    # First is needed because assertEquals was removed in python 3.12
    # Second and third are needed because these are the opposite pair now for some reason
    substituteInPlace tests/test_inotify.py \
      --replace-fail "assertEquals" "assertEqual" \
      --replace-fail "['IN_ISDIR', 'IN_CREATE']" "['IN_CREATE', 'IN_ISDIR']" \
      --replace-fail "['IN_ISDIR', 'IN_DELETE']" "['IN_DELETE', 'IN_ISDIR']"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test__renames" ];

  meta = {
    homepage = "https://github.com/dsoprea/PyInotify";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
