{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  libarchive,
  glibcLocales,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libarchive-c";
  version = "5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-${pname}";
    rev = "refs/tags/${version}";
    sha256 = "sha256-CO9llPIbVTuE74AeohrMAu5ICkuT/MorRlYEEFne6Uk=";
  };

  patches = [
    (fetchpatch {
      name = "fix-tests-with-recent-libarchive.patch";
      url = "https://github.com/Changaco/python-libarchive-c/commit/a56e9402c76c2fb9631651de7bae07b5fbb0b624.patch";
      hash = "sha256-OLwJQurEFAmwZJbQfhkibrR7Rcnc9vpWwBuhKxgmT7g=";
    })
  ];

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  pythonImportsCheck = [ "libarchive" ];

  nativeCheckInputs = [
    glibcLocales
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/Changaco/python-libarchive-c";
    description = "Python interface to libarchive";
    license = licenses.cc0;
  };
}
