{
  version = "3.4.0";
  x86_64-linux = {
    platform = "linux_x86_64";
    cpu = {
      cp312 = "sha256-Fm1m0uhzRD8y5fQrsIv43PCRCblOSrVPRoP7weIFP0s=";
      cp313 = "sha256-WsGFJVAFYgVunlyrq4l6zEkLwZ7PuanONCxk9sHOJ8U=";
    };
    gpu = {
      cu129 = {
        cp312 = "sha256-K5UM/9jLiLOEhnt6zQfqFeCPPftGEtjtkiMsxDD400M=";
        cp313 = "sha256-p4rK055cSH6xp5//s0ix2iWFbnJSviFBGoG8MmmuziY=";
      };
      cu130 = {
        cp312 = "sha256-WXRhLVDaanSpWwE0/93MFdcU4GY31g3GVatY8MOt4N8=";
        cp313 = "sha256-U1F35fO0X/e0PQj8yeGpBVJMWi2SBYzeEbUjLdJWaZQ=";
      };
    };
  };
  aarch64-linux = {
    platform = "linux_aarch64";
    cpu = {
      cp312 = "sha256-aTgMoRPz3L5YBAedW67uAGrPdDV67ZA1ku0FGQUU6Jw=";
      cp313 = "sha256-5IChMV/ZmLscqfmMm0Q979e/Y29sD0AM4NoyYxYu25Y=";
    };
  };
}
