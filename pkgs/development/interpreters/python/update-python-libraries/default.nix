{ python3, runCommand, git }:

runCommand "update-python-libraries" {
  buildInputs = [
    (python3.withPackages(ps: with ps; [ packaging requests toolz ]))
    git
  ];
} ''
  cp ${./update-python-libraries.py} $out
  patchShebangs $out
  substituteInPlace $out --replace 'GIT = "git"' 'GIT = "${git}/bin/git"'
''