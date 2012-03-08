{ kde, cmake }:

kde {
  buildNativeInputs = [ cmake ];

  patches = [ ./files/kde-base-artwork-nokde.patch ];

  cmakeFlags = "-DDATA_INSTALL_DIR=share";

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "2ab8942ba6813c21859077faa2c9fea88ec9a2d7af73bb5911cc4edbe1a04a04";

  meta = {
    description = "KDE KSplashx themes";
  };
}
