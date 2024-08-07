{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  numpy,
  pytest-lazy-fixtures,
  pytestCheckHook,
  pythonOlder,
  scikit-build,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "parselmouth";
  version = "0.4.4";
  pyproject = true;
  build-system = [
    cmake
    scikit-build
    setuptools
    wheel
  ];

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YannickJadoul";
    repo = "Parselmouth";
    # rev = "refs/tags/v${version}";
    rev = "5bbb97a6a33778746b67cd07c084fe5ae91ac437";
    # hash = "sha256-aRA61CNAXCbcZfljUEHne95TL6T8nDUUOM6DTHRpizo=";
    hash = "sha256-BYOTqSWVE/luZCpeUu/i9TDvPH7RvecxJFzEk6jyCSk=";
  };

  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "7bdf0628b1276379886c7f6dda2cef2b3b374f0b";
    sha256 = "sha256-SbzWk4u1Dt/944N+hiAu/zd49dUXTR2BXs2Ki8fZHiI=";
  };

  postPatch = ''
    cp -r --no-preserve=all ${fmt.outPath}/* ./extern/fmt

    # Remove X11 dependency
    # https://github.com/YannickJadoul/Parselmouth/issues/98
    # substituteInPlace praat/sys/CMakeLists.txt --replace " sendpraat.c" ""

    # Fix 'uint32_t' does not name a type error
    # substituteInPlace pybind11/include/pybind11/attr.h --replace "/// Annotation for methods" "#include <stdint.h>"
  '';

  configurePhase = ''
    export MAKEFLAGS=-j$NIX_BUILD_CORES
  '';

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytest-lazy-fixtures pytestCheckHook ];

  pythonImportsCheck = [ "parselmouth" ];

  meta = {
    description = "Praat in Python, the Pythonic way";
    homepage = "https://github.com/YannickJadoul/Parselmouth";
    changelog = "https://github.com/YannickJadoul/Parselmouth/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
