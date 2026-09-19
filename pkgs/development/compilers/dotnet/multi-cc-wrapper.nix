{
  runCommand,
  runtimeShell,
}:
runCommand "multi-cc-wrapper" { env = { inherit runtimeShell; }; } ''
  mkdir -p $out/bin
  substituteAll ${./multi-cc-wrapper.sh} $out/bin/multi-cc
  chmod +x $out/bin/multi-cc
  ln -s multi-cc $out/bin/multi-c++
''
