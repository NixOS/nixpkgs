{
  lib,
  fetchFromGitHub,
  python3Packages,
  mame-tools,
  p7zip,
}:

python3Packages.buildPythonApplication rec {
  pname = "tochd";
  version = "0.13-unstable-2024-06-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thingsiplay";
    repo = "tochd";
    rev = "eea871b51cd4962d23a6426194f6f524e864c0ac";
    hash = "sha256-lpDROCiXyfM4OdXBNGkEhD3T2c8aS8QyF7etHC5tQ8M=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        mame-tools
        p7zip
      ]
    }"
  ];

  postInstall = ''
    mv $out/bin/tochd.py $out/bin/tochd
    install -Dm644 README.md -t $out/share/doc/tochd
    install -Dm644 LICENSE -t $out/share/licenses/tochd
  '';

  meta = {
    description = "Convert game ISO and archives to CD/DVD CHD";
    homepage = "https://github.com/thingsiplay/tochd";
    changelog = "https://github.com/thingsiplay/tochd/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "tochd";
  };
}
