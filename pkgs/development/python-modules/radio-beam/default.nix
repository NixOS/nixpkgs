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
  version = "0.3.9";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "radio_beam"; # Tarball was uploaded with an underscore in this version
    hash = "sha256-m1/qe8ybJlQyE3hGM7MugWMMnAhVB3t6v0tGz42E5kQ=";
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
