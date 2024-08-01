{
  lib,
  fetchPypi,
  fetchpatch2,
  buildPythonPackage,
  setuptools-scm,
  astropy,
  numpy,
  matplotlib,
  scipy,
  six,
  pytestCheckHook,
  pytest-astropy,
}:

buildPythonPackage rec {
  pname = "radio-beam";
  version = "0.3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7AFkuuYLzibwwgz6zrFw0fBXCnGLzdm4OgT+Chve5jU=";
  };

  # Fix distutils deprecation in Python 3.12. See:
  # https://github.com/radio-astro-tools/radio-beam/pull/124
  patches = [
    (fetchpatch2 {
      url = "https://github.com/radio-astro-tools/radio-beam/commit/1eb0216c8d7f5a4494d8d1fe8c79b48425a9c491.patch";
      hash = "sha256-kTJF/cnkJCjJI2psvs+4MWFn/+b8TvUWjdfYu5ot0XU=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    astropy
    numpy
    scipy
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    pytest-astropy
  ];

  pythonImportsCheck = [ "radio_beam" ];

  meta = with lib; {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    changelog = "https://github.com/radio-astro-tools/radio-beam/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
