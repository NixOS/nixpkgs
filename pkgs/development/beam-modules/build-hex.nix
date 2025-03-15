{
  lib,
  buildRebar3,
  fetchHex,
}:

{
  name,
  version,
  hash ? "",
  sha256 ? "",
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
          inherit version hash sha256;
        };
      }
    );
in
lib.fix pkg
