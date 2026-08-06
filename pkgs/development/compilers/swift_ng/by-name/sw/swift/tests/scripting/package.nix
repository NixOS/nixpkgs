{
  runCommand,
  swift,
}:

# Make sure that Swift can load shared libraries and modules when used as a script interpreter.
runCommand "swift-test-scripting"
  {
    nativeBuildInputs = [ swift ];
  }
  ''
    swift ${./script.swift} 10 | grep "Hello, 20.0"
    touch "$out"
  ''
