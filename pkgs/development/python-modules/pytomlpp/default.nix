{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "1.0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bobfang1992";
    repo = "pytomlpp";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-P41jEs1ShpiuSenreE4ykesY2wgBaR7TUKuv3tcD5J0=";
  };

  buildInputs = [ pybind11 ];

  nativeCheckInputs = [
    pytestCheckHook

    python-dateutil
    doxygen
    python
    pelican
    matplotlib
  ];

  # pelican requires > 2.7
  doCheck = !pythonOlder "3.6";

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

  meta = with lib; {
    description = "Python wrapper for tomlplusplus";
    homepage = "https://github.com/bobfang1992/pytomlpp";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
