{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pyschemes";
  version = "unstable-2017-11-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "spy16";
    repo = pname;
    rev = "ca6483d13159ba65ba6fc2f77b90421c40f2bbf2";
    hash = "sha256-PssucudvlE8mztwVme70+h+2hRW/ri9oV9IZayiZhdU=";
  };

  patches = [
    # Fix python 3.10 compatibility. Tracked upstream in
    # https://github.com/spy16/pyschemes/pull/6
    (fetchpatch {
      url = "https://github.com/spy16/pyschemes/commit/23011128c6c22838d4fca9e00fd322a20bb566c4.patch";
      sha256 = "sha256-vDaWxMrn2aC2wmd035EWRZ3cd/XME81z/BWG0f2T9jc=";
    })
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyschemes" ];

  meta = with lib; {
    description = "A library for validating data structures in Python";
    homepage = "https://github.com/spy16/pyschemes";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ gador ];
  };
}
