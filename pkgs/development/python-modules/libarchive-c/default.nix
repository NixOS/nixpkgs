{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  libarchive,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "libarchive-c";
  version = "5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Changaco";
    repo = "python-libarchive-c";
    tag = finalAttrs.version;
    hash = "sha256-JqXTV1aD3k88OlW+8rT3xsDuW34+1xErG7hkupvL7Uo=";
  };

  patches = [
    # https://github.com/Changaco/python-libarchive-c/pull/141
    (fetchpatch {
      url = "https://github.com/Changaco/python-libarchive-c/commit/e0e2a47b2403632642ee932dd56acd11e4a79efe.diff";
      hash = "sha256-C9eD4cGQOIdBYy4ytom49lA/Jaarj7LbSIgjxCk/H84=";
    })
    # https://github.com/Changaco/python-libarchive-c/pull/145
    (fetchpatch {
      url = "https://github.com/Changaco/python-libarchive-c/commit/f38073cfb0147beeb951ee4fa8ef13b442837b65.patch";
      hash = "sha256-QJD59oYSF1cY2h2GeczwkdVOLIqZF5CauBpmKYFDLCA=";
    })
  ];

  postPatch = ''
    substituteInPlace libarchive/ffi.py --replace-fail \
      "find_library('archive')" "'${libarchive.lib}/lib/libarchive${stdenv.hostPlatform.extensions.sharedLibrary}'"

    substituteInPlace tests/test_entry.py \
      --replace-fail "nlink=0 " ""
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "libarchive" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/Changaco/python-libarchive-c";
    description = "Python interface to libarchive";
    license = lib.licenses.cc0;
  };
})
