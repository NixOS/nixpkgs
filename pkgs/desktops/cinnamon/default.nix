{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  xapps = callPackage ./xapps {};
})
