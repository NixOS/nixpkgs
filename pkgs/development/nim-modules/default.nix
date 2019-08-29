{ lib, pkgs, callPackage }:

let
  extractNimbleMeta = with builtins;
    let pkgsList = fromJSON (readFile ./packages_official.json);
    in name: head (filter (pkg: name == pkg.name) pkgsList);

  nimblePackages = self:
    let
      callNimblePackge = name: path: args:
        let
          nimbleMeta = extractNimbleMeta name;
          args' = {
            buildNimblePackage = callPackage ./build-nimble-package args;
          } // args;
        in lib.callPackageWith (pkgs // self) path args';

      autoPackages = with builtins;
        let dir = readDir ./packages;
        in listToAttrs (filter (x: x != null) (map (name:
          if (getAttr name dir) != "directory" then
            null
          else {
            inherit name;
            value = callNimblePackge name (./packages + "/${name}") { };
          }) (attrNames dir)));
    in autoPackages // (rec {
      rocksdb = callNimblePackge "rocksdb" ./packages/rocksdb {
        inherit (pkgs) rocksdb;
      };

      snappy =
        callNimblePackge "snappy" ./packages/snappy { inherit (pkgs) snappy; };
    });

in lib.fix nimblePackages
