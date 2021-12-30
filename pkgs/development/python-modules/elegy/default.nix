{ lib
, fetchFromGitHub
, buildPythonPackage
, cloudpickle
, deepdish
, deepmerge
, dm-haiku
, poetry
, pytest
, pytestcov
, pyyaml
, tables
, tabulate
, tensorboardx
, toolz
, treex
, typing-extensions
}:

buildPythonPackage rec {
  pname = "elegy";
  version = "0.8.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "poets-ai";
    repo = "elegy";
    rev = "${version}";
    sha256 = "11w8lgl31b52w2qri8j8cgzd30sn8i3769g8nkkshvgkjgca9r4g";
  };

  buildInputs = [
    poetry
    pytest
    pytestcov
  ];

  propagatedBuildInputs = [
    cloudpickle
    deepdish
    deepmerge
    dm-haiku
    pyyaml
    tables
    tabulate
    tensorboardx
    treex
    toolz
    typing-extensions
  ];

  pythonImportsCheck = [
    "elegy"
  ];

  meta = with lib; {
    description = "Elegy is a Neural Networks framework based on Jax inspired by Keras and Haiku.";
    homepage = "https://github.com/poets-ai/elegy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
