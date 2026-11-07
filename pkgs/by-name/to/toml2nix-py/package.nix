{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "toml2nix-py";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erooke";
    repo = "toml2nix";
    tag = "v${version}";
    hash = "sha256-9v5oyVcfaZ8l+YrPQSKJezIZJ/uF9Mew9hocm3nggVI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  meta = {
    description = "Convert toml config files to nix";
    mainProgram = "toml2nix";
    homepage = "https://github.com/erooke/toml2nix";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ erooke ];
  };
}
