{
  fetchFromGitHub,
  lib,
  python3Packages,
  unhide,
}:

python3Packages.buildPythonApplication rec {
  pname = "unhide-gui";
  version = "20240510";
  format = "other";

  src = fetchFromGitHub {
    owner = "YJesus";
    repo = "Unhide";
    tag = "v${version}";
    hash = "sha256-CcS/rR/jPgbcF09aM4l6z52kwFhdQI1VZOyDF2/X6Us=";
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
