{
  buildPythonPackage,
  fetchPypi,
  lib,
  pytest,
  pytest-xdist,
  pytest-dependency,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-order";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RFG9iCG6T6IQlFWi/MiCr2DvjlPgnSRNZ2dL4I9W6sM=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-dependency
    pytest-mock
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Pytest plugin that allows you to customize the order in which your tests are run";
    homepage = "https://github.com/pytest-dev/pytest-order";
    license = licenses.mit;
    maintainers = with maintainers; [
      jacg
      Luflosi
    ];
  };
}
