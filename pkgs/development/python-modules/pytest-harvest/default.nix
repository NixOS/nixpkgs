{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, pytest-runner
, pytest
, decopatch
, makefun
, six
, pytestCheckHook
, numpy
, pandas
, tabulate
, pytest-cases
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-harvest";
  version = "1.10.4";
  format = "setuptools";

  disable = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "smarie";
    repo = "python-pytest-harvest";
    rev = version;
    hash = "sha256-ebzE63d7zt9G9HgbLHaE/USZZpUd3y3vd0kNdT/wWw0=";
  };

  patches = [
    ./fix-setup-py.patch
  ];

  # create file, that is created by setuptools_scm
  # we disable this file creation as it touches internet
  postPatch = ''
    echo "version = '${version}'" > pytest_harvest/_version.py
  '';

  buildInputs = [ pytest ];

  nativeBuildInputs = [
    setuptools-scm
    pytest-runner
  ];

  propagatedBuildInputs = [
    decopatch
    makefun
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
    tabulate
    pytest-cases
  ];

  pythonImportsCheck = [ "pytest_harvest" ];

  meta = with lib; {
    description = "Store data created during your `pytest` tests execution, and retrieve it at the end of the session, e.g. for applicative benchmarking purposes";
    homepage = "https://github.com/smarie/python-pytest-harvest";
    changelog = "https://github.com/smarie/python-pytest-harvest/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
