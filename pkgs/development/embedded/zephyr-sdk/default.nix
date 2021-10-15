{ stdenv, lib, fetchurl, python38, which, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "zephyr-sdk";
  version = "0.13.1";

  nativeBuildInputs = [
    python38
    autoPatchelfHook # We can use normal autopatchelf since all the binaries in sysroots are static
    which
  ];

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl
        {
          url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/zephyr-sdk-${version}-linux-x86_64-setup.run";
          sha256 = "14bbzq4as4kgk5s3z41pvdz6221agwkh76q21npzfvvkkz96lb38";
        }
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl
        {
          url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/zephyr-sdk-${version}-linux-aarch64-setup.run";
          sha256 = "1s0y5njccm3xsm3baah6mgglywxwg37zjrfcbr3zzycsxhn901qc";
        }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  dontUnpack = true;

  installPhase = ''
    # Extract outer self-extracting archive
    cp $src $TEMP/installer.run
    chmod +x $TEMP/installer.run
    $TEMP/installer.run --noexec --target $TEMP/outer

    # Run the setup tool
    cd $TEMP/outer
    bash ./setup.sh -d $out -y -norc -nocmake
  '';

  meta = with lib; {
    homepage = "https://www.zephyrproject.org/";
    description = "Collection of compilers and tools for the Zephyr RTOS";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ artemist ];
  };
}
