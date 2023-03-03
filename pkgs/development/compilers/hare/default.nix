{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: {

  harec = pkgs.callPackage ./harec { };
  hare = pkgs.callPackage ./hare { };
})
