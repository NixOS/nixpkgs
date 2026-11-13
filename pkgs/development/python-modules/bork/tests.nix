{
  testers,

  bork,
  cacert,
  git,
}:
let
  # Single env so we do not pollute $PYTHONPATH: separate nativeBuildInputs
  # leak it into bork's PEP517 isolated builds, breaking their dep resolution.
  pythonEnv = bork.pythonModule.withPackages (ps: [
    ps.bork
    ps.pytest
  ]);
in
{
  # a.k.a. `tests.testers.runCommand.bork`
  pytest-network = testers.runCommand {
    name = "bork-pytest-network";
    nativeBuildInputs = [
      pythonEnv
      cacert
      git
    ];
    script = ''
      # Copy the source tree over, and make it writeable
      cp -r ${bork.src} bork/
      find -type d -exec chmod 0755 '{}' '+'

      pytest -v -m network bork/
      touch $out
    '';
  };
}
