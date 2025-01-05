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
  version = "0.3.8";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "radio_beam"; # Tarball was uploaded with an underscore in this version
    hash = "sha256-CE/rcYKO3Duz5zwmJ4gEuqOoO3Uy7sjwOi96HP0Y53A=";
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

  meta = with lib; {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    changelog = "https://github.com/radio-astro-tools/radio-beam/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
