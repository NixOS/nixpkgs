{
  mkDerivation,
  python3,
  qtbase,
}:

mkDerivation {
  pname = "kapidox";
  nativeBuildInputs = [
    python3.pkgs.setuptools
    qtbase
  ];

  buildInputs = with python3.pkgs; [
    jinja2
    pyyaml
    requests
  ];

  postPatch = ''
    sed -i -e 's|"doxy\w\+", ||g' setup.py
  '';

  buildPhase = ''
    runHook preBuild
    ${python3.interpreter} setup.py build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python3.interpreter} setup.py install --prefix="$out"
    runHook postInstall
  '';

  outputs = [ "out" ];
}
