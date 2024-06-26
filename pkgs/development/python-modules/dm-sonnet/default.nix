{
  lib,
  buildPythonPackage,
  click,
  dm-tree,
  docutils,
  etils,
  fetchFromGitHub,
  fetchpatch,
  numpy,
  pythonOlder,
  tabulate,
  tensorflow,
  tensorflow-datasets,
  wrapt,
}:

buildPythonPackage rec {
  pname = "dm-sonnet";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "sonnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-WkloUbqSyPG3cbLG8ktsjdluACkCbUZ7t6rYWst8rs8=";
  };

  patches = [
    (fetchpatch {
      name = "replace-np-bool-with-np-bool_.patch";
      url = "https://github.com/deepmind/sonnet/commit/df5d099d4557a9a81a0eb969e5a81ed917bcd612.patch";
      hash = "sha256-s7abl83osD4wa0ZhqgDyjqQ3gagwGYCdQifwFqhNp34=";
    })
  ];

  propagatedBuildInputs = [
    dm-tree
    etils
    numpy
    tabulate
    wrapt
  ] ++ etils.optional-dependencies.epath;

  passthru.optional-dependencies = {
    tensorflow = [ tensorflow ];
  };

  nativeCheckInputs = [
    click
    docutils
    tensorflow
    tensorflow-datasets
  ];

  pythonImportsCheck = [ "sonnet" ];

  meta = with lib; {
    description = "Library for building neural networks in TensorFlow";
    homepage = "https://github.com/deepmind/sonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
