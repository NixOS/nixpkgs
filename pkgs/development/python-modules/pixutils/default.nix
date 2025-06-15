{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  numpy,
  wheel,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pixutils";
  version = "0-unstable-2025-05-01";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "pixutils";
    rev = "ca8b18be34d43d75199d4636a638173165a47af4";
    sha256 = "sha256-l1bSi+HTEZPMcwh6/GoLWvc8vbh/9z2pk9IJC+3BsYI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "pixutils" ];

  meta = with lib; {
    description = "Python image processing and pixel utilities";
    homepage = "https://github.com/tomba/pixutils";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ phodina ];
    platforms = platforms.unix;
  };
}
