{ lib
, python3Packages
, fetchFromGitHub
, nix
, ronn
}:

python3Packages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.10.1-unstable-2024-04-02";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "vulnix";
    rev = "ebd8ea84553c0fd95bc3042584b495560821500f";
    hash = "sha256-huC520cLPjcmnbh+qOamyVfiIJNrCUpwK+orEp+X2LQ=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--flake8" ""
  '';

  outputs = [ "out" "doc" "man" ];
  nativeBuildInputs = [ ronn ];

  nativeCheckInputs = with python3Packages; [
    freezegun
    pytest
    pytest-cov
  ];

  propagatedBuildInputs = [
    nix
  ] ++ (with python3Packages; [
    click
    colorama
    pyyaml
    requests
    setuptools
    toml
    zodb
  ]);

  postBuild = "make -C doc";

  checkPhase = "py.test src/vulnix";

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
    maintainers = with maintainers; [ ckauhaus ];
  };
}
