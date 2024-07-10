{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  attrs,
  docopt,
  pillow,
  scikit-image,
  scipy,
  numpy,
  aggdraw,
  pytestCheckHook,
  pytest-cov,
  ipython,
  cython,
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.33";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4Y4VLfGwopfeIppxwvGKSuelUDAXg67rM/ES9BrTP24=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    aggdraw
    attrs
    docopt
    ipython
    numpy
    pillow
    scikit-image
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "psd_tools" ];

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    mainProgram = "psd-tools";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
