{
  octave,
  mesa,
  gnuplot,
  fontconfig,
  runCommand,
}:
package:

runCommand "${package.name}-pkg-test"
  {
    nativeBuildInputs = [
      mesa
      gnuplot
      (octave.withPackages (os: [ package ]))
    ];
  }
  ''
    # Put fontconfig cache somewhere writable so gnuplot does not complain.
    export XDG_CACHE_HOME=/tmp
    export FONTCONFIG_PATH='${fontconfig}/etc/fonts/'

    { octave-cli --eval 'pkg test ${package.pname}' || touch FAILED_ERRCODE; } \
      |& tee >( grep --quiet '^Failure Summary:$' && touch FAILED_OUTPUT || : ; cat >/dev/null )
    if [[ -f FAILED_ERRCODE ]]; then
      echo >&2 "octave-cli returned with non-zero exit code."
      false
    elif [[ -f FAILED_OUTPUT ]]; then
      echo >&2 "Test failures detected in output."
      false
    else
      touch $out
    fi
  ''
