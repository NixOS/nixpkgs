{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jmp";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+PefZU1209vvf1SfF8DXiTvKYEnZ4y8iiIr8yKikx9Y=";
  };

  # Wheel requires only `numpy`, but the import needs `jax`.
  propagatedBuildInputs = [
    jax
  ];

  pythonImportsCheck = [
    "jmp"
  ];

  nativeCheckInputs = [
    jaxlib
    pytestCheckHook
  ];

  meta = with lib; {
    description = "This library implements support for mixed precision training in JAX.";
    homepage = "https://github.com/deepmind/jmp";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
