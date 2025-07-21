{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix,
  ronn,
}:

python3Packages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.11.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "vulnix";
    tag = version;
    hash = "sha256-bQjmAmTRP/ce25hSP1nTtuDmUtk46DxkKWtylJRoj3s=";
  };

  __darwinAllowLocalNetworking = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];
  nativeBuildInputs = [ ronn ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    pytestCheckHook
    pytest-cov-stub
  ];

  propagatedBuildInputs =
    [
      nix
    ]
    ++ (with python3Packages; [
      click
      colorama
      pyyaml
      requests
      setuptools
      toml
      zodb
    ]);

  postBuild = "make -C doc";

  pytestFlagsArray = [ "src/vulnix" ];

  postInstall = ''
    install -D -t $doc/share/doc/vulnix README.rst CHANGES.rst
    gzip $doc/share/doc/vulnix/*.rst
    install -D -t $man/share/man/man1 doc/vulnix.1
    install -D -t $man/share/man/man5 doc/vulnix-whitelist.5
  '';

  dontStrip = true;

  meta = with lib; {
    description = "NixOS vulnerability scanner";
    mainProgram = "vulnix";
    homepage = "https://github.com/nix-community/vulnix";
    license = licenses.bsd3;
    maintainers = with maintainers; [ henrirosten ];
  };
}
