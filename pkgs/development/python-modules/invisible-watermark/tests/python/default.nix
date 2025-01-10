{
  image,
  invisible-watermark,
  opencv4,
  python3,
  runCommand,
  stdenvNoCC,
}:

# This test checks if the python code shown in the README works correctly

let
  message = "fnörd1";
  method = "dwtDct";

  pythonWithPackages = python3.withPackages (
    pp: with pp; [
      invisible-watermark
      opencv4
    ]
  );
  pythonInterpreter = pythonWithPackages.interpreter;

  encode = stdenvNoCC.mkDerivation {
    name = "encode";
    realBuilder = pythonInterpreter;
    args = [ ./encode.py ];
    inherit image message method;
  };

  decode = stdenvNoCC.mkDerivation {
    name = "decode";
    realBuilder = pythonInterpreter;
    args = [ ./decode.py ];
    inherit method;
    image = "${encode}/test_wm.png";
    num_bits = (builtins.stringLength message) * 8;
  };
in
runCommand "invisible-watermark-test-python" { } ''
  decoded_message="$(cat '${decode}')"
  if [ '${message}' != "$decoded_message" ]; then
    echo "invisible-watermark did not decode the watermark correctly."
    echo "The original message was ${message} but the decoded message was $decoded_message."
    exit 1
  fi
  touch "$out"
''
