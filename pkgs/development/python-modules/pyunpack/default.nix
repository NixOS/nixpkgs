{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, easyprocess
, entrypoint2
, patool
, cabextract
}:

buildPythonPackage rec {
  pname = "pyunpack";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ponty";
    repo = "pyunpack";
    rev = "refs/tags/${version}";
    hash = "sha256-1MAdiX6+u35f6S8a0ZcIIebZE8bbxTy+0TnMohJ7J6s=";
  };

  postPatch = ''
    substituteInPlace pyunpack/__init__.py \
      --replace \
       '_exepath("patool")' \
       '"${lib.getBin patool}/bin/.patool-wrapped"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    easyprocess
    entrypoint2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    cabextract
  ];

  pytestFlagsArray = [ "-x" ];

  pythonImportsCheck = [ "pyunpack" ];

  disabledTestPaths = [
    # unfree
    "tests/test_rar.py"

    # We get "patool: error: unrecognized arguments: --password 123"
    # The currently packaged version of patool does not support this flag.
    # https://github.com/wummel/patool/issues/114
    # FIXME: Re-enable these once patool is updated
    "tests/test_rarpw.py"
    "tests/test_zippw.py"
  ];

  meta = with lib; {
    description = "Unpack archive files in python";
    homepage = "https://github.com/ponty/pyunpack";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pbsds ];
  };
}
