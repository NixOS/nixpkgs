{
  lib,
  runCommand,
  swift,
}:

# Make sure the REPL works. It’s a bit finicky on Linux.
runCommand "swift-test-repl"
  {
    nativeBuildInputs = [ swift ];
    meta.badPlatforms = [
      # Darwin can’t run this test because it requires `debugserver`, which is non-free.
      # Even if it could use `debugserver`, the build user would need debugging access, which it will not have.
      lib.systems.inspect.patterns.isDarwin
    ];
  }
  ''
    swift repl <<EOF | grep "Saying: Hello, Nixpkgs!"
      func say(message: String) { print("Saying: \(message)") }
      say(message: "Hello, Nixpkgs!")
    EOF
    touch "$out"
  ''
