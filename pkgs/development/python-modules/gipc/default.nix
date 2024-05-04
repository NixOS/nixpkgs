{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jgehrcke";
    repo = "gipc";
    rev = "refs/tags/${version}";
    hash = "sha256-T5TqLanODyzJGyjDZz+75bbz3THxoobYnfJFQxAB76E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "gevent>=1.5,<=21.12.0" "gevent>=1.5"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    gevent
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gipc"
  ];

  meta = with lib; {
    description = "gevent-cooperative child processes and IPC";
    longDescription = ''
      Usage of Python's multiprocessing package in a gevent-powered
      application may raise problems and most likely breaks the application
      in various subtle ways. gipc (pronunciation "gipsy") is developed with
      the motivation to solve many of these issues transparently. With gipc,
      multiprocessing. Process-based child processes can safely be created
      anywhere within your gevent-powered application.
    '';
    homepage = "http://gehrcke.de/gipc";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
