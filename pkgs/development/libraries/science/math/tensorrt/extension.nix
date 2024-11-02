final: prev: let

  inherit (final) callPackage;
  inherit (prev) cudatoolkit cudaVersion lib pkgs;

  ### TensorRT

  buildTensorRTPackage = args:
    callPackage ./generic.nix { } args;

  toUnderscore = str: lib.replaceStrings ["."] ["_"] str;

  majorMinorPatch = str: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion str));

  tensorRTPackages = let
    # Check whether a file is supported for our cuda version
    isSupported = fileData: lib.elem cudaVersion fileData.supportedCudaVersions;
    # Return the first file that is supported. In practice there should only ever be one anyway.
    supportedFile = files: lib.findFirst isSupported null files;

    # Compute versioned attribute name to be used in this package set
    computeName = version: "tensorrt_${toUnderscore version}";

    # Supported versions with versions as keys and file as value
    supportedVersions = lib.recursiveUpdate
      {
        tensorrt = {
          enable = false;
          fileVersionCuda = null;
          fileVersionCudnn = null;
          fullVersion = "0.0.0";
          sha256 = null;
          tarball = null;
          supportedCudaVersions = [ ];
        };
      }
      (lib.mapAttrs' (version: attrs: lib.nameValuePair (computeName version) attrs)
        (lib.filterAttrs (version: file: file != null) (lib.mapAttrs (version: files: supportedFile files) tensorRTVersions)));

    # Add all supported builds as attributes
    allBuilds = lib.mapAttrs (name: file: buildTensorRTPackage (lib.removeAttrs file ["fileVersionCuda"])) supportedVersions;

    # Set the default attributes, e.g. tensorrt = tensorrt_8_4;
    defaultName = computeName tensorRTDefaultVersion;
    defaultBuild = lib.optionalAttrs (allBuilds ? ${defaultName}) { tensorrt = allBuilds.${computeName tensorRTDefaultVersion}; };
  in {
    inherit buildTensorRTPackage;
  } // allBuilds // defaultBuild;

  tarballURL =
  {fullVersion, fileVersionCuda, fileVersionCudnn ? null} :
    "TensorRT-${fullVersion}.Linux.x86_64-gnu.cuda-${fileVersionCuda}"
    + lib.optionalString (fileVersionCudnn != null) ".cudnn${fileVersionCudnn}"
    + ".tar.gz";

  tensorRTVersions = {
    "8.6.1" = [
      rec {
        fileVersionCuda = "12.0";
        fullVersion = "8.6.1.6";
        sha256 = "sha256-D4FXpfxTKZQ7M4uJNZE3M1CvqQyoEjnNrddYDNHrolQ=";
        tarball = tarballURL { inherit fileVersionCuda fullVersion; };
        supportedCudaVersions = [ "12.0" "12.1" ];
      }
    ];
    "8.5.3" = [
      rec {
        fileVersionCuda = "11.8";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.3.1";
        sha256 = "sha256-BNeuOYvPTUAfGxI0DVsNrX6Z/FAB28+SE0ptuGu7YDY=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" "11.8" ];
      }
      rec {
        fileVersionCuda = "10.2";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.3.1";
        sha256 = "sha256-WCt6yfOmFbrjqdYCj6AE2+s2uFpISwk6urP+2I0BnGQ=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "10.2" ];
      }
    ];
    "8.5.2" = [
      rec {
        fileVersionCuda = "11.8";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.2.2";
        sha256 = "sha256-Ov5irNS/JETpEz01FIFNMs9YVmjGHL7lSXmDpgCdgao=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" "11.8" ];
      }
      rec {
        fileVersionCuda = "10.2";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.2.2";
        sha256 = "sha256-UruwQShYcHLY5d81lKNG7XaoUsZr245c+PUpUN6pC5E=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "10.2" ];
      }
    ];
    "8.5.1" = [
      rec {
        fileVersionCuda = "11.8";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.1.7";
        sha256 = "sha256-Ocx/B3BX0TY3lOj/UcTPIaXb7M8RFrACC6Da4PMGMHY=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" "11.8" ];
      }
      rec {
        fileVersionCuda = "10.2";
        fileVersionCudnn = "8.6";
        fullVersion = "8.5.1.7";
        sha256 = "sha256-CcFGJhw7nFdPnSYYSxcto2MHK3F84nLQlJYjdIw8dPM=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "10.2" ];
      }
    ];
    "8.4.0" = [
      rec {
        fileVersionCuda = "11.6";
        fileVersionCudnn = "8.3";
        fullVersion = "8.4.0.6";
        sha256 = "sha256-DNgHHXF/G4cK2nnOWImrPXAkOcNW6Wy+8j0LRpAH/LQ=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" ];
      }
      rec {
        fileVersionCuda = "10.2";
        fileVersionCudnn = "8.3";
        fullVersion = "8.4.0.6";
        sha256 = "sha256-aCzH0ZI6BrJ0v+e5Bnm7b8mNltA7NNuIa8qRKzAQv+I=";
        tarball = tarballURL { inherit fileVersionCuda fileVersionCudnn fullVersion; };
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
    "11.7" = "8.5.3";
    "11.8" = "8.5.3";
    "12.0" = "8.6.1";
    "12.1" = "8.6.1";
  }.${cudaVersion} or "8.4.0";

in tensorRTPackages
