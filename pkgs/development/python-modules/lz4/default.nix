{ lib
, buildPythonPackage
, fetchFromGitHub
, pkgconfig
, psutil
, pytestCheckHook
, python
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "python-lz4";
  version = "4.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  # get full repository in order to run tests
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aVnXCrTh+0Ip+FgYWN7hLw8N3iQCmXSywhReD5RTUfI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    sed -i '/pytest-cov/d' setup.py
  '';

  nativeBuildInputs = [
    pkgconfig
    setuptools-scm
  ];

  pythonImportsCheck = [
    "lz4"
    "lz4.block"
    "lz4.frame"
    "lz4.stream"
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
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
    changelog = "https://github.com/python-lz4/python-lz4/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
