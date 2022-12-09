{ python3, runCommand, git, nix }:

runCommand "update-python-libraries" {
  buildInputs = [
    nix
    (python3.withPackages(ps: with ps; [ packaging requests toolz ]))
    git
  ];
} ''
  cp ${./update-python-libraries.py} $out
  patchShebangs $out
  substituteInPlace $out --replace 'GIT = "git"' 'GIT = "${git}/bin/git"'
''
