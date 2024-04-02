{ lib
, buildPythonPackage
, fetchFromGitHub
, pkg-config
, numpy
, libraw
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "rawpy";
  version = "0.19.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "letmaik";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4/3aDCZWHO9c+HgRC+jLuN9qjNSE2HEN74CLR+Y8i68=";
  };

  RAWPY_USE_SYSTEM_LIBRAW = "1";

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    numpy
    libraw
  ];

  buildInputs = [
    cython
  ];

  nativeCheckInputs = [
    scikit-image
    opencv4
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rawpy"
  ];

  meta = with lib; {
    description = "rawpy is an easy-to-use Python wrapper for the LibRaw library. It also contains some extra functionality for finding and repairing hot/dead pixels";
    homepage = "https://github.com/letmaik/rawpy/tree/main";
    changelog = "https://github.com/letmaik/rawpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ear7h ];
  };
}
