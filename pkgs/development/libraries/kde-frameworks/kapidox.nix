{ mkDerivation, python3, qtbase }:

mkDerivation {
  pname = "kapidox";
  buildInputs = with python3.pkgs; [ jinja2 pyyaml requests ];
  nativeBuildInputs = with python3.pkgs; [ qtbase setuptools ];

  patchPhase = ''
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
