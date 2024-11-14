{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
let
  version = "0.23.1";
in
python3Packages.buildPythonApplication {
  pname = "toml-sort";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = "toml-sort";
    rev = "refs/tags/v${version}";
    hash = "sha256-7V2WBZYAdsA4Tiy9/2UPOcThSNE3ZXM713j57KDCegk=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = [ python3Packages.tomlkit ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  postPatch = ''
    substituteInPlace "tests/test_cli.py" \
      --replace-fail "toml-sort" "$out/bin/toml-sort"
  '';

  meta = {
    mainProgram = "toml-sort";
    homepage = "https://github.com/pappasam/toml-sort";
    description = "Command line utility to sort and format your toml files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
