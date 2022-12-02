{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, matplotlib
, numpy
, pandas
, pillow
, pytest
, pytest-datadir
, pytestCheckHook
, pyyaml
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-regressions";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-s+xM2zTo9idgYnXYuDTGXmDhowc+MmuzcnpCcnPQIh0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pillow
    pytest-datadir
    pyyaml
  ];


  checkInputs = [
    pytestCheckHook
    matplotlib
  ];

  pythonImportsCheck = [
    "pytest_regressions"
    "pytest_regressions.plugin"
  ];

  meta = with lib; {
    description = "Pytest fixtures to write regression tests";
    longDescription = ''
      pytest-regressions makes it simple to test general data, images,
      files, and numeric tables by saving expected data in a data
      directory (courtesy of pytest-datadir) that can be used to verify
      that future runs produce the same data.
    '';
    homepage = "https://github.com/ESSS/pytest-regressions";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
