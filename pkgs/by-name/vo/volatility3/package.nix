{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "volatility3";
  version = "2.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "volatilityfoundation";
    repo = "volatility3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TtkLxzZq7tmLDpCl1UpOqdCWM7t+dgiUmQMsIg3vUGs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3.pkgs; [
    capstone
    jsonschema
    pefile
    pycryptodome
    yara-python
  ];

  preBuild = ''
    export HOME=$(mktemp -d);
  '';

  postFixup = ''
    for executable in vol volshell; do
      wrapProgram $out/bin/$executable \
        --run 'volatility3_data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/volatility3"
               mkdir -p "$volatility3_data_dir/symbols"' \
        --run 'volatility3_cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/volatility3"
               mkdir -p "$volatility3_cache_dir"' \
        --add-flags '--symbol-dirs "''${XDG_DATA_HOME:-$HOME/.local/share}/volatility3/symbols"' \
        --add-flags '--cache-path "''${XDG_CACHE_HOME:-$HOME/.cache}/volatility3"'
    done
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "volatility3" ];

  meta = {
    description = "Volatile memory extraction frameworks";
    homepage = "https://www.volatilityfoundation.org/";
    changelog = "https://github.com/volatilityfoundation/volatility3/releases/tag/${finalAttrs.src.tag}";
    license = {
      # Volatility Software License 1.0
      free = false;
      url = "https://www.volatilityfoundation.org/license/vsl-v1.0";
    };
    maintainers = with lib.maintainers; [
      caverav
      fab
    ];
  };
})
