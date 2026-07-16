{
  interpreter,
  writeText,
  runCommand,
}:

let

  pythonEnv = interpreter.withPackages (ps: [
    ps.tkinter
  ]);

  pythonScript = writeText "myscript.py" ''
    import tkinter
    print(tkinter)
  '';

in
runCommand "${interpreter.name}-tkinter-test" { } ''
  ${pythonEnv}/bin/python ${pythonScript}
  touch $out
''
