{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = version;
    hash = "sha256-5VbxQDK69If5N8EiS8sIKNqHkCAfquOz8nUS7ynp+nA=";
  };

  cargoHash = "sha256-ohfza2ti7Ar/9TV/WoTL5g6CPaONrxtr7nW0qmLdB/8=";

  postPatch = ''
    substituteInPlace tests/utils.rs --replace-fail \
      'target/debug' "target/$(rustc -vV | sed -n 's|host: ||p')/debug"
  '';

  meta = with lib; {
    description = "Log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}
