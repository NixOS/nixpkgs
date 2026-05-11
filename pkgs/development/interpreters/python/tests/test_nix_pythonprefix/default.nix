{
  interpreter,
  writeText,
  runCommand,
}:

let

  python =
    let
      packageOverrides = self: super: {
        typeddep = self.callPackage ./typeddep { };
      };
    in
    interpreter.override {
      inherit packageOverrides;
      self = python;
    };

  pythonEnv = python.withPackages (ps: [
    ps.typeddep
    ps.mypy
  ]);

  pythonScript = writeText "myscript.py" ''
    from typeddep import util
    s: str = util.echo("hello")
    print(s)
  '';

in
runCommand "${interpreter.name}-site-prefix-mypy-test" { } ''
  ${pythonEnv}/bin/mypy ${pythonScript}
  touch $out
''
