{
  stdenvNoCC
, fetchurl
, cacert
, which
, wget
, cmake
, lib
, system ? builtins.currentSystem
  }:
  let
    pname = "zephyr-sdk";
    version = "0.16.8";
    system_fixup = { x86_64-linux = "linux-x86_64"; aarch64-linux = "linux-aarch64"; x86_64-darwin = "macos-x86_64"; aarch64-darwin = "macos-aarch64";};
    url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/${pname}-${version}_${system_fixup.${system}}.tar.xz";
  in
    stdenvNoCC.mkDerivation{
      inherit pname version;
      src = fetchurl { inherit url; sha256 = "0smwgpzikdd1yxj1nw815qg6imfynjwql7pcy6m2ci8yfl940knb";};
      sourceRoot = ".";
      nativeBuildInputs = [ cacert which wget cmake ];
      dontUseCmakeConfigure = true;

      # Zephyr SDK contains multiple patched packages
      # maybe in the future we should use nixpkgs with patches
      # instead
      buildPhase = ''
          bash ${pname}-${version}/setup.sh -t all
      '';

      installPhase = ''
          mkdir -p $out
          mv $name $out/
      '';

      meta = with lib; {
        description = "Software Develpment Kit for Zephyr RTOS";
        longDescription = "The Zephyr Software Development Kit (SDK) includes the toolchains for all supported target architectures as well as the host tools, such as QEMU and OpenOCD, for testing and debugging the Zephyr RTOS.";
        homepage = "https://github.com/zephyrproject-rtos/sdk-ng";
        licence = licences.asl20;
        platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        maintainers = [{
          email = "giancarlo.bonvenuto@gmail.com";
          github = "gBonvenuto";
        githubId = 25495557;
        name = "Giancarlo Bonvenuto";
        }];
      };

    }
