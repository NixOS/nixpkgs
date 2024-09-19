{
  annotated-types,
  buildPythonPackage,
  flit-core,
  lib,
  makeWrapper,
  pydantic,
  pyright,
  pythonOlder,
  rich,
  ruff,
}:
let
  inherit (lib.fileset) toSource unions;
  inherit (lib.trivial) importTOML;
  pyprojectAttrs = importTOML ./pyproject.toml;
  finalAttrs = {
    pname = pyprojectAttrs.project.name;
    inherit (pyprojectAttrs.project) version;
    pyproject = true;
    disabled = pythonOlder "3.12";
    src = toSource {
      root = ./.;
      fileset = unions [
        ./pyproject.toml
        ./cuda_redist_lib
      ];
    };
    nativeBuildInputs = [ makeWrapper ];
    build-system = [ flit-core ];
    dependencies = [
      annotated-types
      pydantic
      rich
    ];
    pythonImportsCheck = [ finalAttrs.pname ];
    nativeCheckInputs = [
      pyright
      ruff
    ];
    passthru.optional-dependencies.dev = [
      pyright
      ruff
    ];
    doCheck = true;
    checkPhase =
      # preCheck
      ''
        runHook preCheck
      ''
      # Check with ruff
      + ''
        echo "Linting with ruff"
        ruff check
        echo "Checking format with ruff"
        ruff format --diff
      ''
      # Check with pyright
      + ''
        echo "Typechecking with pyright"
        pyright --warnings
        echo "Verifying type completeness with pyright"
        pyright --verifytypes ${finalAttrs.pname} --ignoreexternal
      ''
      # postCheck
      + ''
        runHook postCheck
      '';
    meta = with lib; {
      description = pyprojectAttrs.project.description;
      homepage = pyprojectAttrs.project.urls.Homepage;
      maintainers = with maintainers; [ connorbaker ];
    };
  };
in
buildPythonPackage finalAttrs
