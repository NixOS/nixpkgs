{ callPackage, lib, externalProtoc, buildProtobuf, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.5.1.1";
  sha256 = "1h4xydr5j2zg1888ncn8a1jvqq8fgpgckrmjg6lqzy9jpkvqvfdk";
  externalProtoc = externalProtoc;
  buildProtobuf = buildProtobuf;
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
