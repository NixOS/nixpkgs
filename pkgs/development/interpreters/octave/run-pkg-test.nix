{
  octave,
  runCommand,
}:
package:

runCommand
  "${package.name}-pkg-test"
  {
    nativeBuildInputs = [
      (octave.withPackages (os: [ package ]))
    ];
  }
  ''
    octave-cli --eval 'pkg test ${package.pname}'
    touch $out
  ''
