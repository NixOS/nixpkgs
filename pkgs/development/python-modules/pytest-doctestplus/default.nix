{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, packaging
, pytest
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.11.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efcb24a366d3b033d343298c2a60eae418b06803c85373450f10306815c7c632";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # ERROR: usage: __main__.py [options] [file_or_dir] [file_or_dir] [...]
    # __main__.py: error: unrecognized arguments: --remote-data
    "test_remote_data_url"
    "test_remote_data_float_cmp"
    "test_remote_data_ignore_whitespace"
    "test_remote_data_ellipsis"
    "test_remote_data_requires"
    "test_remote_data_ignore_warnings"
  ];

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
