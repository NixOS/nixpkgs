{
  lib,
  buildPythonPackage,
  fetchFromGitea,

  # build-system
  uv-build,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "indicio";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "victorpoughon";
    repo = "indicio";
    tag = finalAttrs.version;
    hash = "sha256-F2afc+Gi1EPxJYfvcIRdiCKpqTObxtU/ae6Y7qijw9Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.9,<0.11.0" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [
    "indicio"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python interface to refractiveindex.info";
    longDescription = ''
      Indicio is a python package that provides offline access to the
      refractiveindex.info database of optical constants.
    '';
    homepage = "https://codeberg.org/victorpoughon/indicio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
