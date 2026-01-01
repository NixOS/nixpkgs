{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
  attrs,
  docopt,
  pillow,
  scikit-image,
  scipy,
  numpy,
  aggdraw,
  pytestCheckHook,
  pytest-cov-stub,
  ipython,
  cython,
}:

buildPythonPackage rec {
  pname = "psd-tools";
<<<<<<< HEAD
  version = "1.12.1";
  pyproject = true;

=======
  version = "1.10.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = "psd-tools";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FmxxLa9KasDE5hl/Hi6fRMnmUKawpm04fHJf7yXJmSI=";
=======
    hash = "sha256-hGalK3iGIp0LaH97E3UTuog8zyJ83zgoqn5NC0krdP8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    aggdraw
    attrs
    docopt
    numpy
    pillow
    scikit-image
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    ipython
  ];

  pythonImportsCheck = [ "psd_tools" ];

  meta = {
    description = "Python package for reading Adobe Photoshop PSD files";
    mainProgram = "psd-tools";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
