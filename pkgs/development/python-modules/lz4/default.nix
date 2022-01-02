{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# native inputs
, pkgconfig
, setuptools-scm

# tests
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "3.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  # get full repository in order to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fqt9aJGqZpfbiYtU8cmm7UQaixZwbTKFBwRfR1B/qic=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    sed -i '/pytest-cov/d' setup.py
  '';

  nativeBuildInputs = [
    setuptools-scm
    pkgconfig
  ];

  pythonImportsCheck = [
    "lz4"
    "lz4.block"
    "lz4.frame"
    "lz4.stream"
  ];

  checkInputs = [
    pytestCheckHook
    psutil
  ];

  # leave build directory, so the installed library gets imported
  preCheck = ''
    pushd tests
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "LZ4 Bindings for Python";
    homepage = "https://github.com/python-lz4/python-lz4";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
