{ lib
, fetchFromGitHub
, buildPythonPackage
, jax
, jaxlib
}:

buildPythonPackage rec {
  pname = "jmp";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "jmp";
    rev = "v${version}";
    sha256 = "1kah1m3v08gmhk1q81iwpyb5q5rxcc0wln7w0kr5zvpml61k7gxp";
  };

  # Wheel requires only `numpy`, but the import needs both `jax` and `jaxlib`.
  propagatedBuildInputs = [
    jax
    jaxlib
  ];

  pythonImportsCheck = [
    "jmp"
  ];

  # checkInputs = [
  #   pytest
  # ];

  # The tests are currently broken both for release and `master`: `AttributeError: module 'jmp' has no attribute '_src'`
  doCheck = false;

  meta = with lib; {
    description = "This library implements support for mixed precision training in JAX.";
    homepage = "https://github.com/deepmind/jmp";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
