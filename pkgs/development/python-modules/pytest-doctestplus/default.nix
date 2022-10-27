{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, packaging
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "0.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f393adf659709a5f111d6ca190871c61808a6f3611bd0a132e27e93b24dd3448";
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

  patches = [
    # Removal of distutils, https://github.com/astropy/pytest-doctestplus/pull/172
    (fetchpatch {
      name = "distutils-removal.patch";
      url = "https://github.com/astropy/pytest-doctestplus/commit/ae2ee14cca0cde0fab355936995fa083529b00ff.patch";
      sha256 = "sha256-uryKV7bWw2oz0glyh2lpGqtDPFvRTo8RmI1N1n15/d4=";
    })
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
    maintainers = with maintainers; [ costrouc ];
  };
}
