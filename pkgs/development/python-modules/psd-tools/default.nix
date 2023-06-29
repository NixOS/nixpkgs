{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, docopt
, pillow
, scikit-image
, aggdraw
, pytestCheckHook
, ipython
, cython
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.27";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kF9L1n9QjGvUKGyAbIypZlnoYCHNz5kSxgquteCmFas=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    aggdraw
    docopt
    ipython
    pillow
    scikit-image
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "psd_tools"
  ];

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
