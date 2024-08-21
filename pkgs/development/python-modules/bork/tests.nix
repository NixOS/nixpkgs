{
  testers,

  bork,
  cacert,
  git,
  pytest,
}:
{
  # a.k.a. `tests.testers.runCommand.bork`
  pytest-network = testers.runCommand {
    name = "bork-pytest-network";
    nativeBuildInputs = [
      bork
      cacert
      git
      pytest
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
