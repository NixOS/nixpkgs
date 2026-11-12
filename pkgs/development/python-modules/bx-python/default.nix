{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  # build-system
  cython,
  numpy,
  setuptools,

  # buildInputs
  zlib,

  # dependencies
  pyparsing,

  # tests
  pytestCheckHook,
  python-lzo,
}:

buildPythonPackage (finalAttrs: {
  pname = "bx-python";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bxlab";
    repo = "bx-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jSS5amnDy25oz9rKW5KFEqROYCdF0P30vtokxqwudIY=";
  };

  # pytest-cython, which provides this option, isn't packaged
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

  dependencies = [
    numpy
    pyparsing
  ];

  pythonImportsCheck = [ "bx" ];

  nativeCheckInputs = [
    pytestCheckHook
    python-lzo
  ];

  # Upstream tests against an editable install: the in-tree `lib/bx` shadows the installed
  # package, so copy the compiled extensions next to their sources.
  # https://github.com/bxlab/bx-python/issues/101
  preCheck = ''
    pushd $out/${python.sitePackages}
    find bx -name "*.so" -exec cp --parents {} $OLDPWD/lib/ \;
    popd
  '';

  postInstall = ''
    cp -r scripts/* $out/bin
  ''
  # This is a small hack; the test suite uses the scripts which need to be patched.
  # Linking the patched scripts in $out back to the working directory allows the tests to run.
  + ''
    rm -rf scripts
    ln -s $out/bin scripts
  '';

  meta = {
    description = "Tools for manipulating biological data, particularly multiple sequence alignments";
    homepage = "https://github.com/bxlab/bx-python";
    changelog = "https://github.com/bxlab/bx-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" ];
  };
})
