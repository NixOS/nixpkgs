# source is <https://github.com/nzbr/pnpm2nix-nzbr/blob/main/lockfile.nix>

{ lib
, runCommand
, remarshal
, fetchurl
, ...
}:

with lib;
rec {

  parseLockfile = lockfile: builtins.fromJSON (readFile (runCommand "toJSON" { } "${remarshal}/bin/yaml2json ${lockfile} $out"));

  processLockfile = { registry, lockfile, noDevDependencies }:
    let
      splitVersion = name: splitString "@" (head (splitString "(" name));
      getVersion = name: last (splitVersion name);
      withoutVersion = name: concatStringsSep "@" (init (splitVersion name));
      switch = options:
        if ((length options) == 0)
        then throw "No matching case found!"
        else
          if ((head options).case or true)
          then (head options).result
          else switch (tail options);
      mkTarball = pkg: contents:
        runCommand "${last (init (splitString "/" (head (splitString "(" pkg))))}.tgz" { } ''
          tar -czf $out -C ${contents} .
        '';
      findTarball = n: v:
        switch [
          {
            case = (v.resolution.type or "") == "git";
            result =
              mkTarball n (
                fetchGit {
                  url = v.resolution.repo;
                  rev = v.resolution.commit;
                  shallow = true;
                }
              );
          }
          {
            case = hasAttrByPath [ "resolution" "tarball" ] v && hasAttrByPath [ "resolution" "integrity" ] v;
            result = fetchurl {
              url = v.resolution.tarball;
              ${head (splitString "-" v.resolution.integrity)} = v.resolution.integrity;
            };
          }
          {
            case = hasPrefix "https://codeload.github.com" (v.resolution.tarball or "");
            result =
              let
                m = strings.match "https://codeload.github.com/([^/]+)/([^/]+)/tar\\.gz/([a-f0-9]+)" v.resolution.tarball;
              in
              mkTarball n (
                fetchGit {
                  url = "https://github.com/${elemAt m 0}/${elemAt m 1}";
                  rev = (elemAt m 2);
                  shallow = true;
                }
              );
          }
          {
            case = (v ? id);
            result =
              let
                split = splitString "/" v.id;
              in
              mkTarball n (
                fetchGit {
                  url = "https://${concatStringsSep "/" (init split)}.git";
                  rev = (last split);
                  shallow = true;
                }
              );
          }
          {
            case = hasPrefix "/" n;
            result =
              let
                name = withoutVersion n;
                baseName = last (splitString "/" (withoutVersion n));
                version = getVersion n;
              in
              fetchurl {
                url = "${registry}/${name}/-/${baseName}-${version}.tgz";
                ${head (splitString "-" v.resolution.integrity)} = v.resolution.integrity;
              };
          }
        ];
    in
    {
      dependencyTarballs =
        unique (
          mapAttrsToList
            findTarball
            (filterAttrs
              (n: v: !noDevDependencies || !(v.dev or false))
              (parseLockfile lockfile).packages
            )
        );

      patchedLockfile =
        let
          orig = parseLockfile lockfile;
        in
        orig // {
          packages = mapAttrs
            (n: v:
              v // (
                if noDevDependencies && (v.dev or false)
                then { resolution = { }; }
                else {
                  resolution.tarball = "file:${findTarball n v}";
                }
              )
            )
            orig.packages;

        };
    };

}

