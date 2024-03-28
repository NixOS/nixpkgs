{ stdenv, lib, fetchzip, gnat, gprbuild, gnatcoll-core, gnatcoll-iconv, gnatcoll-gmp, xmlada }:

stdenv.mkDerivation rec {
  pname = "langkit_support";
  version = "22.0.0";
  src = fetchzip {
    url = "https://github.com/AdaCore/langkit/releases/download/v${version}/langkit_support-${version}.tar.gz";
    hash = "sha256-WSDLpPinTXu8IyOZI8FlB72Bqe/IvhvbHGoEGjVSzeE=";
  };

  nativeBuildInputs = [
    gnat
    gnatcoll-core
    gnatcoll-gmp
    gnatcoll-iconv
    gprbuild
    xmlada
  ];

  LANGKIT_SUPPORT_BUILD_MODE = "prod";


  buildPhase = ''
    runHook preBuild
    gprbuild -j0 -P langkit_support
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    gprinstall --mode=dev -P langkit_support -p -r --prefix=$out -a
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/AdaCore/langkit";
    description = "Language creation framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ ethindp ];
  };
}
