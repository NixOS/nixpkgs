{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {

  harec = callPackage ./harec { };
  hare = callPackage ./hare { };
})
