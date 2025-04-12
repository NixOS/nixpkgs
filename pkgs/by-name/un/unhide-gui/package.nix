{
  fetchFromGitHub,
  lib,
  python3Packages,
  unhide,
}:

python3Packages.buildPythonApplication rec {
  pname = "unhide-gui";
  version = "20220611";
  format = "other";

  src = fetchFromGitHub {
    owner = "YJesus";
    repo = "Unhide";
    rev = "v${version}";
    hash = "sha256-v4otbDhKKRLywH6aP+mbMR0olHbW+jk4TXTBY+iaxdo=";
  };

  propagatedBuildInputs = with python3Packages; [ tkinter ];

  buildInputs = [ unhide ];

  postPatch = ''
    substituteInPlace unhideGui.py \
      --replace-fail "\This" "This" \
      --replace-fail "__credits__" "#__credits__" \
      --replace-fail "./unhide-linux" "${unhide}/bin/unhide-linux" \
      --replace-fail "./unhide-tcp" "${unhide}/bin/unhide-tcp"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/unhideGui}
    cp -R *.py $out/share/unhideGui

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/unhideGui" \
      --set PYTHONPATH "$PYTHONPATH" \
      --add-flags "$out/share/unhideGui/unhideGui.py"

    runHook postFixup
  '';

  meta = {
    description = "Forensic tool to find hidden processes and TCP/UDP ports by rootkits, LKMs or other hiding technique";
    homepage = "https://github.com/YJesus/Unhide";
    changelog = "https://github.com/YJesus/Unhide/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "unhide-gui";
    platforms = lib.platforms.all;
  };
}
