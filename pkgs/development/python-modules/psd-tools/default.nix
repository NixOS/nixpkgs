{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, docopt
, pillow
, scikitimage
, aggdraw
, pytestCheckHook
, ipython
, cython
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RW8v3UeO2tCjKkCqraFw2IfVt2YL3EbixfGsK7pOQYI=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    aggdraw
    docopt
    ipython
    pillow
    scikitimage
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
