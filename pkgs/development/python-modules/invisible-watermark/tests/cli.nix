{
  image,
  method,
  invisible-watermark,
  runCommand,
  testName,
  withOnnx,
}:

# This file runs one test case.
# There are six test cases in total. method can have three possible values and
# withOnnx two possible values. 3 * 2 = 6.
#
# The case where the method is rivaGan and invisible-watermark is built
# without onnx is expected to fail and this case is handled accordingly.
#
# The test works by first encoding a message into a test image,
# then decoding the message from the image again and checking
# if the message was decoded correctly.

let
  message =
    if method == "rivaGan" then
      "asdf" # rivaGan only supports 32 bits
    else
      "fnörd1";
  length = (builtins.stringLength message) * 8;
  invisible-watermark' = invisible-watermark.override { inherit withOnnx; };
  expected-exit-code = if method == "rivaGan" && !withOnnx then "1" else "0";
in
runCommand "invisible-watermark-test-${testName}" { nativeBuildInputs = [ invisible-watermark' ]; }
  ''
    set +e
    invisible-watermark \
      --verbose \
      --action encode \
      --type bytes \
      --method '${method}' \
      --watermark '${message}' \
      --output output.png \
      '${image}'
    exit_code="$?"
    set -euf -o pipefail
    if [ "$exit_code" != '${expected-exit-code}' ]; then
      echo "Exit code of invisible-watermark was $exit_code while ${expected-exit-code} was expected."
      exit 1
    fi
    if [ '${expected-exit-code}' == '1' ]; then
      echo 'invisible-watermark failed as expected.'
      touch "$out"
      exit 0
    fi
    decoded_message="$(invisible-watermark \
                        --action decode \
                        --type bytes \
                        --method '${method}' \
                        --length '${toString length}' \
                        output.png \
                      )"

    if [ '${message}' != "$decoded_message" ]; then
      echo "invisible-watermark did not decode the watermark correctly."
      echo "The original message was ${message} but the decoded message was $decoded_message."
      exit 1
    fi
    touch "$out"
  ''
