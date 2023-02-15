{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python

# native inputs
, pkgconfig
, setuptools-scm

# tests
, psutil
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "4.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  # get full repository in order to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-XWkCZhBapjtzH3g3t+xXiB2f54p3Xw0+UBKVNH+gGHQ=";
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

  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ];

  # for lz4.steam
  PYLZ4_EXPERIMENTAL = true;

  # prevent local lz4 directory from getting imported as it lacks native extensions
  preCheck = ''
    rm -r lz4
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  meta = with lib; {
    description = "LZ4 Bindings for Python";
    homepage = "https://github.com/python-lz4/python-lz4";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
