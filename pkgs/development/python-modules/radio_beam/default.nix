{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, astropy
, numpy
, matplotlib
, scipy
, six
, pytestCheckHook
, pytest-astropy
}:

buildPythonPackage rec {
  pname = "radio_beam";
  version = "0.3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "radio-beam";
    sha256 = "e032257f1501303873f251c00c74b1188180785c79677fb4443098d517852309";
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

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    pytest-astropy
  ];

  meta = {
    description = "Tools for Beam IO and Manipulation";
    homepage = "http://radio-astro-tools.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ smaret ];
  };
}


