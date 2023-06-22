{ buildPythonPackage
, fetchFromGitHub
, numpy
, jax
, jaxlib
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jmp";
  version = "0.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+PefZU1209vvf1SfF8DXiTvKYEnZ4y8iiIr8yKikx9Y=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-dependencies = {
    jax = [
      jax
      jaxlib
    ];
  };

  pythonImportsCheck = [
    "jmp"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = passthru.optional-dependencies.jax;

  meta = with lib; {
    description = "This library implements support for mixed precision training in JAX.";
    homepage = "https://github.com/deepmind/jmp";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
