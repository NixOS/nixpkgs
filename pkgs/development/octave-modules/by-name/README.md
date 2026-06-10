# Name-based Octave package directories

The structure of this directory is identical to the one described in
[/pkgs/by-name/README.md](../../../by-name/README.md).
The only difference is the scope:

```nix
{
  lib,
  # You can get OctavePackages attributes directly
  buildOctavePackage,
  io,
}:

buildOctavePackage {
  # ...
  requiredOctavePackages = [
    io
  ];
}
```
