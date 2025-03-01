{
  lib,
  buildRebar3,
  fetchHex,
}:

{
  name,
  version,
  sha256,
  builder ? buildRebar3,
  hexPkg ? name,
  ...
}@attrs:

let
  pkg =
    self:
    builder (
      attrs
      // {

        src = fetchHex {
          pkg = hexPkg;
          inherit version;
          inherit sha256;
        };
      }
    );
in
lib.fix pkg
