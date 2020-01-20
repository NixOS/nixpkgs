{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  cjs = callPackage ./cjs { };
  xapps = callPackage ./xapps { };
})
