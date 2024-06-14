{ lib, ... }:
let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) const;
  inherit (lib.types) nonEmptyListOf enum;
in
{
  options = mapAttrs (const mkOption) {
    outputs = {
      description = ''
        The outputs provided by a package.

        A `bin` output requires that we have a non-empty `bin` directory containing at least one file with the
        executable bit set.

        A `dev` output requires that we have at least one of the following non-empty directories:

        - `include`
        - `lib/pkgconfig`
        - `share/pkgconfig`
        - `lib/cmake`
        - `share/aclocal`

        A `doc` output requires that we have at least one of the following non-empty directories:

        - `share/info`
        - `share/doc`
        - `share/gtk-doc`
        - `share/devhelp`
        - `share/man`

        A `lib` output requires that we have a non-empty lib directory containing at least one shared library.

        A `python` output requires that we have a non-empty `python` directory.

        A `sample` output requires that we have a non-empty `samples` directory.

        A `static` output requires that we have a non-empty lib directory containing at least one static library.

        A `stubs` output requires that we have a non-empty `lib/stubs` or `stubs` directory containing at least one
        shared or static library.
      '';
      type = nonEmptyListOf (enum [
        "out" # Always present
        "bin"
        "dev"
        "doc"
        "lib"
        "python"
        "sample"
        "static"
        "stubs"
      ]);
    };
  };
}
