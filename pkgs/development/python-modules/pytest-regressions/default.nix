{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  matplotlib,
  numpy,
  pandas,
  pillow,
  pytest,
  pytest-datadir,
  pytestCheckHook,
  pyyaml,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-regressions";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gYx4hMHP87q/ie67AsvCezB4VrGYVCfCTVLLgSoQb9k=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pytest-datadir
    pyyaml
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "pytest_regressions"
    "pytest_regressions.plugin"
  ];

  optional-dependencies = {
    dataframe = [
      pandas
      numpy
    ];
    image = [
      numpy
      pillow
    ];
    num = [
      numpy
      pandas
    ];
  };

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
    maintainers = [ ];
  };
}
