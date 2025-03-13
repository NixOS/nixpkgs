{ expect, runCommand, tritty }:

runCommand "tritty-tests-simple" {
  nativeBuildInputs = [
    expect
    tritty
  ];
  passAsFile = [ "expectScript" ];
  expectScript = ''
    # 200 bytes per second
    spawn "tritty" "-b" "1600"
    proc abort_timeout { } { send_user "Timeout!" ; exit 2 }
    proc abort_eof { } { send_user "End of file!" ; exit 2 }
    expect_before timeout abort_timeout
    expect_before eof abort_eof
    set timeout 60

    expect "\$"
    # some 1400 bytes worth of output
    send "for i in 1 2 3 4 5 6 7 8 9 10; do echo 'some output, so that the total number of bytes in this test is a bit more predictable, which helps with the assertion about time at the end'; done\r"
    expect "\$"
    send "echo -n he; echo llo\r"
    expect "hello"
    send "exit\r"
    expect "exit"

    # unset eof handler
    expect_before eof { }
    expect eof
  '';
} ''
  (
    set -x
    [[ hello == "$(echo hello | trickle)" ]]
  )
  start=$(date +%s)
  expect $expectScriptPath
  end=$(date +%s)
  echo "Test took $((end - start)) seconds"
  (
    set -x
    # 1400 bytes at 200 bytes per second should take at least 7 seconds,
    # (given that there's some other output and a bit of input as well)
    [[ $((end - start)) -ge 7 ]]
  )
  touch $out
''
