{ lib
, bash
, python
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, substituteAll
, git
, isPyPy
, pytestCheckHook
, pytest-mock
, freezegun
, jinja2
, future
, binaryornot
, click
, requests
, python-slugify
, pyyaml
, arrow
, rich
}:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "2.3.0";
  format = "setuptools";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lCp5SYF0f21/Q51uSdOdyRqaZBKDYUFgyTxHTHLCliE=";
  };

  patches = [
    (substituteAll {
      src = ./patch-test-paths.diff;
      python = python.interpreter;
      bash = "${bash}/bin/bash";
    })
  ];

  # this yields a lighter derivation without the pytest-cov dependency
  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov-report term-missing --cov=cookiecutter" ""
  '';

  propagatedBuildInputs = [
    binaryornot
    jinja2
    click
    pyyaml
    python-slugify
    requests
    arrow
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    freezegun
    git
  ];

  preCheck = ''
    # some tests access the user config path inside the home directory
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # tests if the CLI can be invoked in a clean environment by clearing
    # PYTHONPATH. this works when run in a virtual environment but not in
    # nixpkgs, which uses PYTHONPATH to supply package dependencies
    "test_should_invoke_main"
  ];

  meta = with lib; {
    homepage = "https://github.com/cookiecutter/cookiecutter";
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
