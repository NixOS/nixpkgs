{ lib
, cairo
, fribidi
}:

{ ... }:

{ CFLAGS ? ""
, ...
}:

{
  CFLAGS = "${CFLAGS} -isystem ${lib.getOutput "dev" fribidi}/include/fribidi -isystem ${lib.getOutput "dev" cairo}/include";
}
