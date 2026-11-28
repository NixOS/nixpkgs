{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  postgresql,
  unittestCheckHook,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "pgsanity";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markdrago";
    repo = "pgsanity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-58AGU1wWNpARerVKXRPJoRFCbyqCT2Zeo/qEOsSle+8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.19,<0.9.0" uv_build
  '';

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlags = [ "--start-directory=test" ];

  propagatedBuildInputs = [ postgresql ];

  # To find "ecpg"
  nativeBuildInputs = [ (lib.getDev postgresql) ];

  meta = {
    homepage = "https://github.com/markdrago/pgsanity";
    description = "Checks the syntax of Postgresql SQL files";
    mainProgram = "pgsanity";
    longDescription = ''
      PgSanity checks the syntax of Postgresql SQL files by
      taking a file that has a list of bare SQL in it,
      making that file look like a C file with embedded SQL,
      run it through ecpg and
      let ecpg report on the syntax errors of the SQL.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nalbyuites ];
  };
})
