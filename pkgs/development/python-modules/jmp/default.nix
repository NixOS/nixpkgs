{ buildPythonPackage
, fetchFromGitHub
, jax
, jaxlib
, lib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jmp";
  # As of 2022-01-01, the latest stable version (0.0.2) fails tests with recent JAX versions,
  # IIUC it's fixed in https://github.com/deepmind/jmp/commit/4969392f618d7733b265677143d8c81e44085867
  version = "unstable-2021-10-03";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "4b94370b8de29b79d6f840b09d1990b91c1afddd";
    sha256 = "0hh4cmp93wjyidj48gh07vhx2kjvpwd23xvy79bsjn5qaaf6q4cm";
  };

  # Wheel requires only `numpy`, but the import needs `jax`.
  propagatedBuildInputs = [
    jax
  ];

  pythonImportsCheck = [
    "jmp"
  ];

  checkInputs = [
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
