{
  absl-py,
  buildPythonPackage,
  contextlib2,
  fetchPypi,
  fetchurl,
  lib,
  pyyaml,
}:

let
  requirements = fetchurl {
    url = "https://raw.githubusercontent.com/google/ml_collections/7f749a281c69f9d0b339c05ecb94b80d95029f25/requirements.txt";
    sha256 = "1xb351hiscj4zmajfkql3swpacdp6lmz8iwdvwwdx2zqw9a62zps";
  };
  requirements-test = fetchurl {
    url = "https://raw.githubusercontent.com/google/ml_collections/7f749a281c69f9d0b339c05ecb94b80d95029f25/requirements-test.txt";
    sha256 = "0r457k2nrg5jkf093r0x29yf8xwy6l7jxi6al0fh7mmnfrhr9cb1";
  };
in
buildPythonPackage rec {
  pname = "ml-collections";
  version = "0.1.1";
  format = "setuptools";

  # ml-collections does not have any git release tags. See https://github.com/google/ml_collections/issues/8.
  src = fetchPypi {
    inherit version;
    pname = "ml_collections";
    hash = "sha256-P+/McuxDOqHl0yMHo+R0u7Z/QFvoFOpSohZr/J2+aMw=";
  };

  # The pypi source archive does not include requirements.txt or
  # requirements-test.txt. See https://github.com/google/ml_collections/issues/7.
  postPatch = ''
    cp ${requirements} requirements.txt
    cp ${requirements-test} requirements-test.txt
  '';

  propagatedBuildInputs = [
    absl-py
    contextlib2
    pyyaml
  ];

  # The official test suite uses bazel. With pytestCheckHook there are name
  # conflicts between files and tests have assumptions that are broken by the
  # nix-build environment, eg. re module names and __file__ attributes.
  doCheck = false;

  pythonImportsCheck = [ "ml_collections" ];

  meta = with lib; {
    description = "ML Collections is a library of Python collections designed for ML usecases.";
    homepage = "https://github.com/google/ml_collections";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
