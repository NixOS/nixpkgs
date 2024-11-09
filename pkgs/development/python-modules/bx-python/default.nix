{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  numpy,
  pyparsing,
  cython,
  zlib,
  python-lzo,
  pytestCheckHook,
  setuptools,
  oldest-supported-numpy,
}:

buildPythonPackage rec {
  pname = "bx-python";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-I5yc8i9xoievaZbgwHSQQSVvs1VnNa66Q883T4dCYYw=";
  };

  postPatch = ''
    # pytest-cython, which provides this option, isn't packaged
    substituteInPlace pytest.ini \
      --replace-fail "--doctest-cython" ""
  '';

  build-system = [
    setuptools
    cython
    oldest-supported-numpy
  ];

  buildInputs = [ zlib ];

  dependencies = [
    numpy
    pyparsing
  ];

  nativeCheckInputs = [
    python-lzo
    pytestCheckHook
  ];

  # https://github.com/bxlab/bx-python/issues/101
  doCheck = false;

  postInstall = ''
    cp -r scripts/* $out/bin

    # This is a small hack; the test suite uses the scripts which need to
    # be patched. Linking the patched scripts in $out back to the
    # working directory allows the tests to run
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = {
    description = "Tools for manipulating biological data, particularly multiple sequence alignments";
    homepage = "https://github.com/bxlab/bx-python";
    changelog = "https://github.com/bxlab/bx-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };
}
