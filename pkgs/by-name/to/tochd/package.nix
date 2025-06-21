{
  lib,
  fetchFromGitHub,
  python3,
  mame-tools,
  p7zip,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tochd";
  version = "0-unstable-2024-06-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thingsiplay";
    repo = "tochd";
    rev = "eea871b51cd4962d23a6426194f6f524e864c0ac";
    hash = "sha256-lpDROCiXyfM4OdXBNGkEhD3T2c8aS8QyF7etHC5tQ8M=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    mame-tools
    p7zip
  ];

  postInstall = ''
    mkdir -p $out/{share/licenses,share/doc/tochd}
    mv $out/bin/tochd.py $out/bin/tochd
    install -TDm644 README.md $out/share/doc/tochd/README.md
    install -TDm644 LICENSE $out/share/licenses/tochd/LICENSE
  '';

  meta = {
    description = "Convert game ISO and archives to CD/DVD CHD";
    homepage = "https://github.com/thingsiplay/tochd.git";
    changelog = "https://github.com/thingsiplay/tochd/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "tochd";
    platforms = lib.platforms.all;
  };
}
