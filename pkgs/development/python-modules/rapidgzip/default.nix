{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pythonOlder,
  setuptools,
  nasm,
}:

buildPythonPackage rec {
  pname = "rapidgzip";
  version = "0.14.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+u1GAToaYqUZPElhWolmg+pcFO1HRLy0vRhpsUIFUdg=";
  };

  prePatch = ''
    # pythonRelaxDeps doesn't work here
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools >= 61.2, < 72" "setuptools" \
      --replace-fail "cython >= 3, < 3.1" cython
  '';

  nativeBuildInputs = [
    cython
    nasm
    setuptools
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "rapidgzip" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python library for parallel decompression and seeking within compressed gzip files";
    mainProgram = "rapidgzip";
    homepage = "https://github.com/mxmlnkn/rapidgzip";
    changelog = "https://github.com/mxmlnkn/rapidgzip/blob/rapidgzip-v${version}/python/rapidgzip/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit; # dual MIT and asl20, https://internals.rust-lang.org/t/rationale-of-apache-dual-licensing/8952
=======
    license = licenses.mit; # dual MIT and asl20, https://internals.rust-lang.org/t/rationale-of-apache-dual-licensing/8952
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
