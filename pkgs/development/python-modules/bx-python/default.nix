{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  numpy,
  cython,
  zlib,
  python-lzo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZpZjh7OXdUY7rd692h7VYHzC3qCrDKFme6r+wuG7GP4=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--doctest-cython" ""
  '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  buildInputs = [ zlib ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    python-lzo
  ];

  postInstall = ''
    cp -r scripts/* $out/bin

    # This is a small hack; the test suite uses the scripts which need to
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  preCheck = ''
    rm -r lib
  '';

  meta = with lib; {
    description = "Tools for manipulating biological data, particularly multiple sequence alignments";
    homepage = "https://github.com/bxlab/bx-python";
    changelog = "https://github.com/bxlab/bx-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
