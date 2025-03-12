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

  useFetchCargoVendor = true;
  cargoHash = "sha256-QkdnmeXor2K0c5m/TV5hYl1oSPWpykPfZy/ZRqFUt1s=";

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
