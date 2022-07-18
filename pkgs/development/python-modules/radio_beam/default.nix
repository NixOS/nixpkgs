{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, astropy
, numpy
, scipy
, six
, pytestCheckHook
, pytest-doctestplus
}:

buildPythonPackage rec {
  pname = "radio_beam";
  version = "0.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "radio-beam";
    sha256 = "e34902d91713ccab9f450b9d3e82317e292cf46a30bd42f9ad3c9a0519fcddcd";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    numpy
    scipy
    six
  ];

  checkInputs = [
    pytestCheckHook
    pytest-doctestplus
  ];

  # Tests must be run in the build directory
  preCheck = ''
    cd build/lib
  '';

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}


