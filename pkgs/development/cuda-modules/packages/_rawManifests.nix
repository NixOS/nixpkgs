{
  lib,
  runCommand,
  wget,
  formats,
  cacert,

  _cuda,
}:

let
  manifests =
    runCommand "manifests"
      rec {
        __structuredAttrs = true;
        nativeBuildInputs = [ wget ];

        env = {
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
        };

        distNames = [
          "cuda"
          "cutensor"
          "cusparselt"
          "cudnn"
        ];
        urls = map (name: "https://developer.download.nvidia.com/compute/${name}/redist/") distNames;

        # Build a bigger manifest when backporting to 25.05
        # inherit (known."2025-05-23") includeManifests outputHash;

        # Use the smaller subset on nixos-unstable (e.g. discards pre-11.4 cuda)
        inherit (known."prehistoric") includeManifests outputHash;
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";

        passthru = {
          inherit
            dbIfd
            ifdManifestPaths
            known
            ;
          inherit exportOld;
          exportNew =
            assert validAfterExport;
            exportNew;
          exportNewUnstripped = exportDb dbIfd.config;
          exportTwice = exportDb dbAfterExport.config;
        };
      }
      ''
        set -eu
        set -o pipefail

        withTrace() {
          echo "$@" >&2
          $@
        }

        isKnown () {
          for path in "''${includeManifests[@]}" ; do
            if [[ "$1" == "$path" ]]; then
              return
            fi
          done
          return 1
        }

        for i in ''${!distNames[*]} ; do
          url=''${urls[$i]}
          distName=''${distNames[$i]}
          withTrace mkdir "$distName"
          withTrace pushd "$distName"
          withTrace wget "$url" --ca-certificate=$SSL_CERT_FILE --recursive --level=1 --no-directories -A .json || true
          withTrace popd
        done

        echo "Installing outputs" >&2
        for i in ''${!distNames[*]} ; do
          distName=''${distNames[$i]}
          withTrace mkdir -p "$out/$distName"
          for f in ./"$distName"/*.json ; do
            if isKnown "$f" ; then
              withTrace cp "$f" "$out/$distName"/
            else
              echo "NEW MANIFEST HAS BEEN PUBLISHED AND IS BEING OMITTED FROM THE FOD: $f" >&2
            fi
          done
        done

        for f in "''${includeManifests[@]}" ; do
          if ! [[ -f "$f" ]] ; then
            echo "An expected manifest is missing: $f" >&2
            exit 1
          fi
        done
      '';
  ifdManifestPaths =
    let
      root = "${manifests}";
      childrenPaths =
        root:
        lib.mapAttrs (name: type: {
          inherit type;
          path = root + "/${name}";
        }) (builtins.readDir root);
    in
    lib.flatten (
      lib.flatten (
        lib.mapAttrsToList (
          name:
          { type, path }:
          lib.optionals (type == "directory") (
            lib.mapAttrsToList (name: { path, ... }: lib.optionals (lib.hasSuffix ".json" name) [ path ]) (
              childrenPaths path
            )
          )
        ) (childrenPaths root)
      )
    );

  mergeData = import ../_cuda/db;

  dbIfd = mergeData {
    manifests = ifdManifestPaths;
    extraModules = [ keepOldOutputs ]; # Again, no dynamically generated feature_*.json
  };
  keepOldOutputs =
    { config, ... }:
    {
      # Keep (PName ⇒ OutputName ⇒ ()) around until we can generate it dynamically.
      config.package.outputs = lib.filterAttrs (
        pname: _: lib.hasAttr pname config.package.pname
      ) _cuda.db.package.outputs;
      config.output = _cuda.db.output;
    };
  dbForExport = mergeData {
    manifests = ifdManifestPaths;
    extraModules = [
      ../_cuda/db/schema-export.nix
      keepOldOutputs
    ];
    _includeReleaseFiles = false;
  };
  dbAfterExport = mergeData {
    manifests = [ ];
    extraModules = [
      {
        imports = [
          (lib.importJSON (exportNew + "/blobs.json"))
          (lib.importJSON (exportNew + "/outputs.json"))
          (lib.importJSON (exportNew + "/packages.json"))
        ];
        _file = ./_dbExport.nix;
      }
    ];
  };
  validAfterExport = dbIfd.validConfig == dbAfterExport.validConfig;

  exportNew = exportDb dbForExport.config;
  exportOld = exportDb _cuda.db;
  exportDb =
    db:
    runCommand "cudb"
      {
        srcs = [
          ((formats.json { }).generate "blobs.json" {
            archive.sha256 = db.archive.sha256;
          })
          ((formats.json { }).generate "outputs.json" {
            package.outputs = db.package.outputs;
          })
          ((formats.json { }).generate "packages.json" {
            package = lib.removeAttrs db.package [ "outputs" ];
            inherit (db)
              release
              license
              system
              ;
          })
        ];
      }
      ''
        mkdir $out
        for s in $srcs ; do
          cp "$s" "$out"/"''${s#*-}"
        done
      '';

  known.prehistoric.outputHash = "sha256-ofz+wHc6Wtc0hfpgGPL/Osw+E4OOZJvvCMyVSC75DAU=";
  known.prehistoric.includeManifests = [
    "./cusparselt/redistrib_0.3.0.json"
    "./cusparselt/redistrib_0.4.0.json"
    "./cusparselt/redistrib_0.5.0.json"
    "./cusparselt/redistrib_0.5.1.json"
    "./cusparselt/redistrib_0.5.2.json"
    "./cusparselt/redistrib_0.6.0.json"
    "./cusparselt/redistrib_0.6.1.json"
    "./cusparselt/redistrib_0.6.2.json"
    "./cusparselt/redistrib_0.6.3.json"
    "./cusparselt/redistrib_0.7.0.json"
    "./cusparselt/redistrib_0.7.1.json"
    "./cutensor/redistrib_1.3.3.json"
    "./cutensor/redistrib_1.4.0.json"
    "./cutensor/redistrib_1.5.0.json"
    "./cutensor/redistrib_1.6.2.json"
    "./cutensor/redistrib_1.7.0.json"
    "./cutensor/redistrib_2.0.2.json"
    "./cutensor/redistrib_2.1.0.json"
    "./cudnn/redistrib_8.5.0.96.json"
    "./cudnn/redistrib_8.5.0.json"
    "./cudnn/redistrib_8.6.0.json"
    "./cudnn/redistrib_8.7.0.84.json"
    "./cudnn/redistrib_8.7.0.json"
    "./cudnn/redistrib_8.8.0.121.json"
    "./cudnn/redistrib_8.8.0.json"
    "./cudnn/redistrib_8.8.1.3.json"
    "./cudnn/redistrib_8.8.1.json"
    "./cudnn/redistrib_8.9.0.131.json"
    "./cudnn/redistrib_8.9.0.json"
    "./cudnn/redistrib_8.9.1.23.json"
    "./cudnn/redistrib_8.9.1.json"
    "./cudnn/redistrib_8.9.2.26.json"
    "./cudnn/redistrib_8.9.2.json"
    "./cudnn/redistrib_8.9.3.json"
    "./cudnn/redistrib_8.9.4.25.json"
    "./cudnn/redistrib_8.9.4.json"
    "./cudnn/redistrib_8.9.5.29.json"
    "./cudnn/redistrib_8.9.5.30.json"
    "./cudnn/redistrib_8.9.5.json"
    "./cudnn/redistrib_8.9.6.50.json"
    "./cudnn/redistrib_8.9.6.json"
    "./cudnn/redistrib_8.9.7.29.json"
    "./cudnn/redistrib_8.9.7.json"
    "./cudnn/redistrib_9.0.0.json"
    "./cudnn/redistrib_9.1.0.json"
    "./cudnn/redistrib_9.1.1.json"
    "./cudnn/redistrib_9.2.0.json"
    "./cudnn/redistrib_9.2.1.json"
    "./cudnn/redistrib_9.3.0.json"
    "./cudnn/redistrib_9.4.0.json"
    "./cudnn/redistrib_9.5.0.json"
    "./cudnn/redistrib_9.5.1.json"
    "./cudnn/redistrib_9.6.0.json"
    "./cudnn/redistrib_9.7.0.json"
    "./cudnn/redistrib_9.7.1.json"
    "./cudnn/redistrib_9.8.0.json"
    "./cudnn/redistrib_9.9.0.json"
    "./cudnn/redistrib_9.10.0.json"
    "./cuda/redistrib_11.4.4.json"
    "./cuda/redistrib_11.5.2.json"
    "./cuda/redistrib_11.6.2.json"
    "./cuda/redistrib_11.7.1.json"
    "./cuda/redistrib_11.8.0.json"
    "./cuda/redistrib_12.0.1.json"
    "./cuda/redistrib_12.1.1.json"
    "./cuda/redistrib_12.2.2.json"
    "./cuda/redistrib_12.3.2.json"
    "./cuda/redistrib_12.4.1.json"
    "./cuda/redistrib_12.5.1.json"
    "./cuda/redistrib_12.6.3.json"
    "./cuda/redistrib_12.8.1.json"
  ];
  known."2025-05-23".outputHash = "sha256-+ZHxMpXlwR67d6l+s+GqmcTqsdK81ay2q++mGb0eZjA=";
  known."2025-05-23".includeManifests = known.prehistoric.includeManifests ++ [
    "./cuda/redistrib_11.0.3.json"
    "./cuda/redistrib_11.1.1.json"
    "./cuda/redistrib_11.2.0.json"
    "./cuda/redistrib_11.2.1.json"
    "./cuda/redistrib_11.2.2.json"
    "./cuda/redistrib_11.3.0.json"
    "./cuda/redistrib_11.3.1.json"
    "./cuda/redistrib_11.4.0.json"
    "./cuda/redistrib_11.4.1.json"
    "./cuda/redistrib_11.4.2.json"
    "./cuda/redistrib_11.4.3.json"
    "./cuda/redistrib_11.5.0.json"
    "./cuda/redistrib_11.5.1.json"
    "./cuda/redistrib_11.6.0.json"
    "./cuda/redistrib_11.6.1.json"
    "./cuda/redistrib_11.7.0.json"
    "./cuda/redistrib_12.0.0.json"
    "./cuda/redistrib_12.1.0.json"
    "./cuda/redistrib_12.2.0.json"
    "./cuda/redistrib_12.2.1.json"
    "./cuda/redistrib_12.3.0.json"
    "./cuda/redistrib_12.3.1.json"
    "./cuda/redistrib_12.4.0.json"
    "./cuda/redistrib_12.5.0.json"
    "./cuda/redistrib_12.6.0.json"
    "./cuda/redistrib_12.6.1.json"
    "./cuda/redistrib_12.6.2.json"
    "./cuda/redistrib_12.8.0.json"
    "./cuda/redistrib_12.9.0.json"
    "./cudnn/redistrib_9.10.1.json"
    "./cutensor/redistrib_1.3.2.json"
    "./cutensor/redistrib_1.6.0.json"
    "./cutensor/redistrib_1.6.1.json"
    "./cutensor/redistrib_2.0.0.json"
    "./cutensor/redistrib_2.0.1.json"
    "./cutensor/redistrib_2.0.2.1.json"
    "./cutensor/redistrib_2.2.0.json"
  ];
in
manifests
