{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "thonny";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = "v${version}";
    hash = "sha256-RnjnXB5jU13uwRpL/Pn14QY7fRbRkq09Vopc3fv+z+Y=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  desktopItems = [
    (makeDesktopItem {
      name = "Thonny";
      exec = "thonny";
      icon = "thonny";
      desktopName = "Thonny";
      comment = "Python IDE for beginners";
      categories = [
        "Development"
        "IDE"
      ];
    })
  ];

  dependencies =
    with python3.pkgs;
    (
      [
        jedi
        pyserial
        tkinter
        docutils
        pylint
        mypy
        pyperclip
        asttokens
        send2trash
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        dbus-next
      ]
    );

  preFixup = ''
    wrapProgram "$out/bin/thonny" \
       --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath ${python3.pkgs.jedi})
  '';

  postInstall = ''
    install -Dm644 ./packaging/icons/thonny-48x48.png $out/share/icons/hicolor/48x48/apps/thonny.png
  '';

  # Tests need a DISPLAY
  doCheck = false;

  meta = {
    description = "Python IDE for beginners";
    longDescription = ''
      Thonny is a Python IDE for beginners. It supports different ways
      of stepping through the code, step-by-step expression
      evaluation, detailed visualization of the call stack and a mode
      for explaining the concepts of references and heap.
    '';
    homepage = "https://www.thonny.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leenaars ];
    platforms = lib.platforms.unix;
    mainProgram = "thonny";
  };
}
