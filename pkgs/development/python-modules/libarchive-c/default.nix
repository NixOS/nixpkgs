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
  version = "5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-${pname}";
    tag = version;
    sha256 = "sha256-JqXTV1aD3k88OlW+8rT3xsDuW34+1xErG7hkupvL7Uo=";
  };

  patches = [
    # https://github.com/Changaco/python-libarchive-c/pull/141
    (fetchpatch {
      url = "https://github.com/Changaco/python-libarchive-c/commit/e0e2a47b2403632642ee932dd56acd11e4a79efe.diff";
      hash = "sha256-C9eD4cGQOIdBYy4ytom49lA/Jaarj7LbSIgjxCk/H84=";
    })
  ];

  LC_ALL = "en_US.UTF-8";

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace-fail \
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
