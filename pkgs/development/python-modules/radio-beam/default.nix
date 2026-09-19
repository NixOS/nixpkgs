{
  lib,
  fetchPypi,
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
  version = "0.3.10";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "radio_beam"; # Tarball was uploaded with an underscore in this version
    hash = "sha256-0iFPtfQEAW6K3N+R/DovVWvXeepPnzi4crC+cStHJ2o=";
  };

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

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    changelog = "https://github.com/radio-astro-tools/radio-beam/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
