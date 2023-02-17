final: prev: let

  inherit (final) callPackage;
  inherit (prev) cudatoolkit cudaVersion lib pkgs;
  inherit (prev.lib.versions) major;

  ### CuDNN

  buildCuDnnPackage = args:
    let
      useCudatoolkitRunfile = lib.versionOlder cudaVersion "11.3.999";
    in
    callPackage ./generic.nix { inherit useCudatoolkitRunfile; } args;

  toUnderscore = str: lib.replaceStrings ["."] ["_"] str;

  majorMinorPatch = str: lib.concatStringsSep "." (lib.take 3 (lib.splitVersion str));

  cuDnnPackages = with lib; let
    # Check whether a file is supported for our cuda version
    isSupported = fileData: elem cudaVersion fileData.supportedCudaVersions;
    # Return the first file that is supported. In practice there should only ever be one anyway.
    supportedFile = files: findFirst isSupported null files;
    # Supported versions with versions as keys and file as value
    supportedVersions = filterAttrs (version: file: file !=null ) (mapAttrs (version: files: supportedFile files) cuDnnVersions);
    # Compute versioned attribute name to be used in this package set
    computeName = version: "cudnn_${toUnderscore version}";
    # Add all supported builds as attributes
    allBuilds = mapAttrs' (version: file: nameValuePair (computeName version) (buildCuDnnPackage (removeAttrs file ["fileVersion"]))) supportedVersions;
    # Set the default attributes, e.g. cudnn = cudnn_8_3_1;
    defaultBuild = { "cudnn" = if allBuilds ? ${computeName cuDnnDefaultVersion}
      then allBuilds.${computeName cuDnnDefaultVersion}
      else throw "cudnn-${cuDnnDefaultVersion} does not support your cuda version ${cudaVersion}"; };
  in allBuilds // defaultBuild;

  cuDnnVersions = let
    urlPrefix = "https://developer.download.nvidia.com/compute/redist/cudnn";
  in {
    "7.4.2" = [
      rec {
        fileVersion = "10.0";
        fullVersion = "7.4.2.24";
        hash = "sha256-Lt/IagK1DRfojEeJVaMy5qHoF05+U6NFi06lH68C2qM=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-10.0-linux-x64-v${fullVersion}.tgz";
        supportedCudaVersions = [ "10.0" ];
      }
    ];
    "7.6.5" = [
      rec {
        fileVersion = "10.0";
        fullVersion = "7.6.5.32";
        hash = "sha256-KDVeOV8LK5OsLIO2E2CzW6bNA3fkTni+GXtrYbS0kro=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${cudatoolkit.majorVersion}-linux-x64-v${fullVersion}.tgz";
        supportedCudaVersions = [ "10.0" ];
      }
      rec {
        fileVersion = "10.1";
        fullVersion = "7.6.5.32";
        hash = "sha256-fq7IA5osMKsLx1jTA1iHZ2k972v0myJIWiwAvy4TbLM=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${cudatoolkit.majorVersion}-linux-x64-v${fullVersion}.tgz";
        supportedCudaVersions = [ "10.1" ];
      }
      rec {
        fileVersion = "10.2";
        fullVersion = "7.6.5.32";
        hash = "sha256-fq7IA5osMKsLx1jTA1iHZ2k972v0myJIWiwAvy4TbLN=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${cudatoolkit.majorVersion}-linux-x64-v${fullVersion}.tgz";
        supportedCudaVersions = [ "10.2" ];
      }
    ];
    "8.0.5" = [
      rec {
        fileVersion = "10.1";
        fullVersion = "8.0.5.39";
        hash = "sha256-kJCElSmIlrM6qVBjo0cfk8NmJ9esAcF9w211xl7qSgA=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-805/support-matrix/index.html
        supportedCudaVersions = [ "10.1" ];
      }
      rec {
        fileVersion = "10.2";
        fullVersion = "8.0.5.39";
        hash = "sha256-IfhMBcZ78eyFnnfDjM1b8VSWT6HDCPRJlZvkw1bjgvM=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-805/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.0";
        fullVersion = "8.0.5.39";
        hash = "sha256-ThbueJXetKixwZS4ErpJWG730mkCBRQB03F1EYmKm3M=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-805/support-matrix/index.html
        supportedCudaVersions = [ "11.0" ];
      }
      rec {
        fileVersion = "11.1";
        fullVersion = "8.0.5.39";
        hash = "sha256-HQRr+nk5navMb2yxUHkYdUQ5RC6gyp4Pvs3URvmwDM4=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-805/support-matrix/index.html
        supportedCudaVersions = [ "11.1" ];
      }
    ];
    "8.1.1" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.1.1.33";
        hash = "sha256-Kkp7mabpv6aQ6xm7QeSVU/KnpJGls6v8rpAOFmxbbr0=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-811/support-matrix/index.html#cudnn-versions-810-811
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.2";
        fullVersion = "8.1.1.33";
        hash = "sha256-mKh4TpKGLyABjSDCgbMNSgzZUfk2lPZDPM9K6cUCumo=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-811/support-matrix/index.html#cudnn-versions-810-811
        supportedCudaVersions = [ "11.0" "11.1" "11.2" ];
      }
    ];
    "8.2.4" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.2.4.15";
        hash = "sha256-0jyUoxFaHHcRamwSfZF1+/WfcjNkN08mo0aZB18yIvE=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-824/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.4";
        fullVersion = "8.2.4.15";
        hash = "sha256-Dl0t+JC5ln76ZhnaQhMQ2XMjVlp58FoajLm3Fluq0Nc=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/cudnn-${fileVersion}-linux-x64-v${fullVersion}.tgz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-824/support-matrix/index.html
        supportedCudaVersions = [  "11.0" "11.1" "11.2" "11.3" "11.4" ];
      }
    ];
    "8.3.3" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.3.3.40";
        hash = "sha256-2FVPKzLmKV1fyPOsJeaPlAWLAYyAHaucFD42gS+JJqs=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-833/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.5";
        fullVersion = "8.3.3.40";
        hash = "sha256-6r6Wx1zwPqT1N5iU2RTx+K4UzqsSGYnoSwg22Sf7dzE=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-833/support-matrix/index.html
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" ];
      }
    ];
    "8.4.1" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.4.1.50";
        hash = "sha256-I88qMmU6lIiLVmaPuX7TTbisgTav839mssxUo3lQNjg=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-841/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.6";
        fullVersion = "8.4.1.50";
        hash = "sha256-7JbSN22B/KQr3T1MPXBambKaBlurV/kgVhx2PinGfQE=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-841/support-matrix/index.html
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" ];
      }
    ];
    "8.5.0" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.5.0.96";
        hash = "sha256-1mzhbbzR40WKkHnQLtJHhg0vYgf7G8a0OBcCwIOkJjM=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-850/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.7";
        fullVersion = "8.5.0.96";
        hash = "sha256-VFSm/ZTwCHKMqumtrZk8ToXvNjAuJrzkO+p9RYpee20=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-850/support-matrix/index.html
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" ];
      }
    ];
    "8.6.0" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.6.0.163";
        hash = "sha256-t4sr/GrFqqdxu2VhaJQk5K1Xm/0lU4chXG8hVL09R9k=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-860/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.8";
        fullVersion = "8.6.0.163";
        hash = "sha256-u8OW30cpTGV+3AnGAGdNYIyxv8gLgtz0VHBgwhcRFZ4=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-860/support-matrix/index.html
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" "11.8" ];
      }
    ];
    "8.7.0" = [
      rec {
        fileVersion = "10.2";
        fullVersion = "8.7.0.84";
        hash = "sha256-bZhaqc8+GbPV2FQvvbbufd8VnEJgvfkICc2N3/gitRg=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-870/support-matrix/index.html
        supportedCudaVersions = [ "10.2" ];
      }
      rec {
        fileVersion = "11.8";
        fullVersion = "8.7.0.84";
        hash = "sha256-l2xMunIzyXrnQAavq1Fyl2MAukD1slCiH4z3H1nJ920=";
        url = "${urlPrefix}/v${majorMinorPatch fullVersion}/local_installers/${fileVersion}/cudnn-linux-x86_64-${fullVersion}_cuda${major fileVersion}-archive.tar.xz";
        # https://docs.nvidia.com/deeplearning/cudnn/archives/cudnn-870/support-matrix/index.html
        supportedCudaVersions = [ "11.0" "11.1" "11.2" "11.3" "11.4" "11.5" "11.6" "11.7" "11.8" ];
      }
    ];
  };

  # Default attributes
  cuDnnDefaultVersion = {
    "10.0" = "7.4.2";
    "10.1" = "8.0.5";
    "10.2" = "8.7.0";
    "11.0" = "8.7.0";
    "11.1" = "8.7.0";
    "11.2" = "8.7.0";
    "11.3" = "8.7.0";
    "11.4" = "8.7.0";
    "11.5" = "8.7.0";
    "11.6" = "8.7.0";
    "11.7" = "8.7.0";
    "11.8" = "8.7.0";
  }.${cudaVersion} or "8.7.0";

in cuDnnPackages
