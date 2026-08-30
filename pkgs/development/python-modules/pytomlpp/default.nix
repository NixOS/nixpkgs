{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pybind11,
  pytestCheckHook,
  python-dateutil,
  doxygen,
  python,
  pelican,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "pytomlpp";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bobfang1992";
    repo = "pytomlpp";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-RRsjnZK0FJiSkpWxurs9vJFyo2SUAKyFKXoJ8bcsHKI=";
  };

  # The latest setuptools has deprecated `setup_requires` and will attempt to automatically invoke `pip` to install dependencies during the build.
  patches = [ ./0001-remove-setup_requires.patch ];

  buildInputs = [ pybind11 ];

  nativeCheckInputs = [
    pytestCheckHook

    python-dateutil
    doxygen
    python
    pelican
    matplotlib
  ];

  doCheck = true;

  disabledTests = [
    # incompatible with pytest7
    # https://github.com/bobfang1992/pytomlpp/issues/66
    "test_loads_valid_toml_files"
    "test_round_trip_for_valid_toml_files"
    "test_decode_encode_binary"
  ];

  preCheck = ''
    cd tests
  '';

  pythonImportsCheck = [ "pytomlpp" ];

  meta = {
    description = "Python wrapper for tomlplusplus";
    homepage = "https://github.com/bobfang1992/pytomlpp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
