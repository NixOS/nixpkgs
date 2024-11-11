{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inotify";
  version = "unstable-2020-08-27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "PyInotify";
    rev = "f77596ae965e47124f38d7bd6587365924dcd8f7";
    sha256 = "X0gu4s1R/Kg+tmf6s8SdZBab2HisJl4FxfdwKktubVc=";
    fetchSubmodules = false;
  };

  postPatch = ''
    # Needed because assertEquals was removed in python 3.12
    substituteInPlace tests/test_inotify.py \
      --replace-fail "assertEquals" "assertEqual" \
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # Disable these tests as they're flaky.
  # The returned list can be in a different order, which causes the tests to fail.
  disabledTests = [
    "test__automatic_new_watches_on_new_paths"
    "test__cycle"
    "test__renames"
  ];

  meta = with lib; {
    homepage = "https://github.com/dsoprea/PyInotify";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
