{ runCommand, udpipe1 }:

runCommand "udpipe1-test-run"
  {
    nativeBuildInputs = [ udpipe1 ];
  }
  ''
    diff -U3 --color=auto <(udpipe --version|head -n1) <(echo 'UDPipe version 1.3.1 (using UniLib 3.3.1,')
    touch $out
  ''
