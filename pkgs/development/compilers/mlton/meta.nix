{
  lib,
}:
{
  description = "Open-source, whole-program, optimizing Standard ML compiler";
  longDescription = ''
    MLton is an open source, whole-program optimizing compiler for the Standard ML programming language.
    MLton aims to produce fast executables, and to encourage rapid prototyping and modular programming
    by eliminating performance penalties often associated with the use of high-level language features.
    MLton development began in 1997, and continues to this day with a growing worldwide community of
    developers and users, who have helped to port MLton to a number of platforms.
    Description taken from http://en.wikipedia.org/wiki/Mlton .
  '';

  homepage = "http://mlton.org/";
  license = lib.licenses.smlnj;
  platforms = [
    "i686-linux"
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];
}
