<<<<<<< HEAD
{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, pythonOlder
, substituteAll
, colorama
, contourpy
, jinja2
=======
{ buildPythonPackage
, fetchPypi
, futures ? null
, isPy27
, isPyPy
, jinja2
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mock
, numpy
, nodejs
, packaging
<<<<<<< HEAD
, pandas
, pillow
, tornado
, pytestCheckHook
, pyyaml
, setuptools
, setuptools-git-versioning
, xyzservices
, beautifulsoup4
, channels
, click
, colorcet
, coverage
, firefox
, geckodriver
, isort
, json5
, nbconvert
, networkx
, psutil
, pygments
, pygraphviz
, pytest
, pytest-asyncio
, pytest-xdist
, pytest-timeout
, requests
, scipy
, selenium
, toml
, typing-extensions
=======
, pillow
#, pytestCheckHook#
, pytest
, python-dateutil
, pyyaml
, selenium
, six
, substituteAll
, tornado
, typing-extensions
, pytz
, flaky
, networkx
, beautifulsoup4
, requests
, nbconvert
, icalendar
, pandas
, pythonImportsCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bokeh";
  # update together with panel which is not straightforward
<<<<<<< HEAD
  version = "3.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-spWbhSTWnsTniGvDZAdEXwqS4fGVMNO/xARSNqG3pv8=";
  };

  src_test = fetchFromGitHub {
    owner = "bokeh";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PK9iLOCcivr4oF9Riq73dzxGfxzWRk3bdrCCpRrTv5g=";
=======
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7zOAEWGvN5Zlq3o0aE8iCYYeOu/VyAOiH7u5nZSHSwM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./hardcode-nodejs-npmjs-paths.patch;
      node_bin = "${nodejs}/bin/node";
      npm_bin = "${nodejs}/bin/npm";
    })
  ];

<<<<<<< HEAD
  nativeBuildInputs = [
    colorama
    nodejs
    setuptools
    setuptools-git-versioning
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    channels
    click
    colorcet
    coverage
    firefox
    geckodriver
    isort
    json5
    nbconvert
    networkx
    psutil
    pygments
    pygraphviz
    pytest
    pytest-asyncio
    pytest-xdist
    pytest-timeout
    requests
    scipy
    selenium
    toml
    typing-extensions
  ];

  propagatedBuildInputs = [
    jinja2
    contourpy
    numpy
    packaging
    pandas
    pillow
    pyyaml
    tornado
    xyzservices
  ];

  doCheck = false; # need more work
  pytestFlagsArray = "tests/test_defaults.py";
  pythonImportsCheck = [ "bokeh" ];
  preCheck = ''
    cp -rv ''${src_test}/tests/* ./tests/
  '';
=======
  disabled = isPyPy || isPy27;

  nativeBuildInputs = [
    pythonImportsCheckHook
  ];

  pythonImportsCheck = [
    "bokeh"
  ];

  nativeCheckInputs = [
    mock
    pytest
    pillow
    selenium
    pytz
    flaky
    networkx
    beautifulsoup4
    requests
    nbconvert
    icalendar
    pandas
  ];

  propagatedBuildInputs = [
    pillow
    jinja2
    python-dateutil
    six
    pyyaml
    tornado
    numpy
    packaging
    typing-extensions
  ]
  ++ lib.optionals ( isPy27 ) [
    futures
  ];

  # This test suite is a complete pain. Somehow it can't find its fixtures.
  doCheck = false;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Statistical and novel interactive HTML plots for Python";
    homepage = "https://github.com/bokeh/bokeh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
