{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,
  wheel,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dedupe-pylbfgs";
  version = "0.2.0.16";
  pyproject = true;

  # NOTE: This is a fork of larsmans/pylbfgs maintained by dedupeio
  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "pylbfgs";
    tag = "${version}";
    hash = "sha256-H416dgZQxyqsnhmlK5keW8cJWY6gea4mebVuP0IEVOU=";
  };

  postPatch = ''
    # Remove coverage flag from pytest configuration
    substituteInPlace setup.cfg \
      --replace-fail "addopts = --cov lbfgs" ""
  '';

  build-system = [
    cython
    numpy
    setuptools
    wheel
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Prevent importing from source during test collection (only $out has compiled extensions)
  preCheck = ''
    rm -rf lbfgs
  '';

  pythonImportsCheck = [
    "lbfgs"
  ];

  meta = {
    description = "Python wrapper for L-BFGS and OWL-QN optimization algorithms";
    homepage = "https://github.com/dedupeio/pylbfgs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
