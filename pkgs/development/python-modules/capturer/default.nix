{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
  humanfriendly,
  pytestCheckHook,
  setuptools,
=======
  humanfriendly,
  pytestCheckHook,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "capturer";
  version = "3.0";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-capturer";
    rev = version;
    sha256 = "0fwrxa049gzin5dck7fvwhdp1856jrn0d7mcjcjsd7ndqvhgvjj1";
  };

<<<<<<< HEAD
  patches = [
    # https://github.com/xolox/python-capturer/pull/16
    (fetchpatch {
      name = "python314-compat.patch";
      url = "https://github.com/xolox/python-capturer/commit/3d0a9a040ecaa78ce2d39ec76ff5084ee7be6653.patch";
      hash = "sha256-NW+X6wdXMHSLswO7M7/YeIyHu+EDYTLJE/mBkqyhKUM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ humanfriendly ];
=======
  propagatedBuildInputs = [ humanfriendly ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # hangs on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [ pytestCheckHook ];

<<<<<<< HEAD
  meta = {
    description = "Easily capture stdout/stderr of the current process and subprocesses";
    homepage = "https://github.com/xolox/python-capturer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
=======
  meta = with lib; {
    description = "Easily capture stdout/stderr of the current process and subprocesses";
    homepage = "https://github.com/xolox/python-capturer";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
