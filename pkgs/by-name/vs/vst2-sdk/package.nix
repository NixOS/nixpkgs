{
  lib,
  fetchzip,
}:
fetchzip rec {
  name = "vst2-sdk-${version}"; # cannot be `pname`, as `fetchzip` expects `name`
  version = "2018-06-11";
  url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/vstsdk3610_11_06_2018_build_37.zip";
  hash = "sha256-TyPy8FsXWB8LRz0yr38t3d5xxAxGufAn0dsyrg1JXBA=";

  # Only keep the VST2_SDK directory
  stripRoot = false;
  postFetch = ''
    mv $out/VST_SDK/VST2_SDK/* $out/
    rm -rf $out/VST_SDK
  '';

  meta = {
    description = "VST2 source development kit";
    longDescription = ''
      VST2 is proprietary, and deprecated by Steinberg.
      As such, it should only be used for legacy reasons.
    '';
    license = [ lib.licenses.unfree ];
  };
}
