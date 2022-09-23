{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, pkg-config
, fuse3
, trio
, python
, pytestCheckHook
, pytest-trio
, which
}:

buildPythonPackage rec {
  pname = "pyfuse3";
  version = "3.2.1";

  disabled = pythonOlder "3.5";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "libfuse";
    repo = "pyfuse3";
    rev = "release-${version}";
    hash = "sha256-JGbp2bSI/Rvyys1xMd2o34KlqqBsV6B9LhuuNopayYA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pkg-config'" "'$(command -v $PKG_CONFIG)'"
  '';

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [ fuse3 ];

  propagatedBuildInputs = [ trio ];

  preBuild = ''
    ${python.pythonForBuild.interpreter} setup.py build_cython
  '';

  checkInputs = [
    pytestCheckHook
    pytest-trio
    which
    fuse3
  ];

  # Checks if a /usr/bin directory exists, can't work on NixOS
  disabledTests = [ "test_listdir" ];

  pythonImportsCheck = [
    "pyfuse3"
    "pyfuse3_asyncio"
  ];

  meta = with lib; {
    description = "Python 3 bindings for libfuse 3 with async I/O support";
    homepage = "https://github.com/libfuse/pyfuse3";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ nyanloutre dotlambda ];
  };
}
