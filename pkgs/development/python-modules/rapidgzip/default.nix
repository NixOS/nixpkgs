{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools,
  nasm,
}:

buildPythonPackage rec {
  pname = "rapidgzip";
  version = "0.14.5";
  pyproject = true;

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

  meta = {
    description = "Python library for parallel decompression and seeking within compressed gzip files";
    mainProgram = "rapidgzip";
    homepage = "https://github.com/mxmlnkn/rapidgzip";
    changelog = "https://github.com/mxmlnkn/rapidgzip/blob/rapidgzip-v${version}/python/rapidgzip/CHANGELOG.md";
    license = lib.licenses.mit; # dual MIT and asl20, https://internals.rust-lang.org/t/rationale-of-apache-dual-licensing/8952
    maintainers = with lib.maintainers; [ mxmlnkn ];
  };
}
