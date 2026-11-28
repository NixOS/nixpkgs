{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  meson-python,
  pkg-config,

  # buildInputs
  flint,
  gmp,
  mpfr,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-flint";
  version = "0.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flintlib";
    repo = "python-flint";
    tag = finalAttrs.version;
    hash = "sha256-egcBhNjNP6+zyYctagAqSAD1w58ux6nW9BJklOO5NMQ=";
  };

  # Upstream caps Cython to tested versions (<3.3)
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"cython >=3.1,<3.3"' '"cython >=3.1"'
  '';

  build-system = [
    cython
    meson-python
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    flint
    gmp
    mpfr
  ];

  # Upstream caps flint (<3.7) and Cython (<3.3) to tested versions
  mesonFlags = [ "-Dflint_version_check=false" ];

  pythonImportsCheck = [ "flint" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Run the test suite shipped with the installed package
  pytestFlags = [
    "--pyargs"
    "flint.test"
  ];

  meta = {
    description = "Python bindings for FLINT and Arb";
    homepage = "https://github.com/flintlib/python-flint";
    changelog = "https://github.com/flintlib/python-flint/blob/${finalAttrs.src.tag}/README.md#changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
