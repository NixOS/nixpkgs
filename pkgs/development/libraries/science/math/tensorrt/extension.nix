final: prev: let

  inherit (final) callPackage;
  inherit (prev) cudatoolkit cudaVersion lib pkgs;

  ### TensorRT

  buildTensorRTPackage = args:
    callPackage ./generic.nix { } args;

  toUnderscore = str: lib.replaceStrings ["."] ["_"] str;

  majorMinorPatch = str: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion str));

  tensorRTPackages = with lib; let
    # Check whether a file is supported for our cuda version
    isSupported = fileData: elem cudaVersion fileData.supportedCudaVersions;
    # Return the first file that is supported. In practice there should only ever be one anyway.
    supportedFile = files: findFirst isSupported null files;
    # Supported versions with versions as keys and file as value
    supportedVersions = filterAttrs (version: file: file !=null ) (mapAttrs (version: files: supportedFile files) tensorRTVersions);
    # Compute versioned attribute name to be used in this package set
    computeName = version: "tensorrt_${toUnderscore version}";
    # Add all supported builds as attributes
    allBuilds = mapAttrs' (version: file: nameValuePair (computeName version) (buildTensorRTPackage (removeAttrs file ["fileVersionCuda"]))) supportedVersions;
    # Set the default attributes, e.g. tensorrt = tensorrt_8_4;
    defaultBuild = { "tensorrt" = allBuilds.${computeName tensorRTDefaultVersion}; };
  in allBuilds // defaultBuild;

  tensorRTVersions = {
    "8.4.0" = [
      rec {
        fileVersionCuda = "11.6";
        fileVersionCudnn = "8.3";
        fullVersion = "8.4.0.6";
        sha256 = "sha256-DNgHHXF/G4cK2nnOWImrPXAkOcNW6Wy+8j0LRpAH/LQ=";
        tarball = "TensorRT-${fullVersion}.Linux.x86_64-gnu.cuda-${fileVersionCuda}.cudnn${fileVersionCudnn}.tar.gz";
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" ];
      }
      rec {
        fileVersionCuda = "10.2";
        fileVersionCudnn = "8.3";
        fullVersion = "8.4.0.6";
        sha256 = "sha256-aCzH0ZI6BrJ0v+e5Bnm7b8mNltA7NNuIa8qRKzAQv+I=";
        tarball = "TensorRT-${fullVersion}.Linux.x86_64-gnu.cuda-${fileVersionCuda}.cudnn${fileVersionCudnn}.tar.gz";
        supportedCudaVersions = [ "10.2" ];
      }
    ];
  };

  # Default attributes
  tensorRTDefaultVersion = {
    "10.2" = "8.4.0";
    "11.0" = "8.4.0";
    "11.1" = "8.4.0";
    "11.2" = "8.4.0";
    "11.3" = "8.4.0";
    "11.4" = "8.4.0";
    "11.5" = "8.4.0";
    "11.6" = "8.4.0";
  }.${cudaVersion};

in tensorRTPackages
