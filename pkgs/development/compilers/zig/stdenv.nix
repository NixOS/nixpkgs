{
  stdenv,
  overrideCC,
  zig,
}:
overrideCC stdenv zig.cc
