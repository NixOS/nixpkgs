{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  which,
  libcap,
  makeWrapper,
  nix-update-script,
  openonload,
}:

stdenv.mkDerivation rec {
  pname = "tcpdirect";
  version = "9.0.2.45";

  src = fetchFromGitHub {
    owner = "Xilinx-CNS";
    repo = "tcpdirect";
    rev = "tcpdirect-${version}";
    hash = "sha256-7VQwep078hXdXE4pqGUe2CLqnPdDuWupcyuC+NCM5Ms=";
  };

  nativeBuildInputs = [
    which
    makeWrapper
  ];

  buildInputs = [
    libcap
    libpcap
    openonload
  ];

  enableParallelBuilding = true;
  makeFlags = [
    "CITOOLS_LIB=${lib.getDev openonload}/lib/libcitools1.a"
    "CIUL_LIB=${lib.getDev openonload}/lib/libciul1.a"
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $lib/lib $dev/lib $dev/include

    cp -dv \
      build/bin/zf_internal/shared/* \
      build/bin/zf_apps/shared/* \
      build/bin/zf_stackdump \
      build/bin/trade_sim/shared/* \
      $out/bin

    cp -dv build/lib/libonload_zf.so* $lib/lib
    cp -dv build/lib/libonload_zf_static.a $dev/lib
    cp -rdv src/include/zf $dev/include

    mkdir -p $dev/lib/pkgconfig
    export dash_l="-lonload_zf"
    substituteAll ${./tcpdirect.pc.in} $dev/lib/pkgconfig/tcpdirect.pc
    export dash_l="-l:libonload_zf_static.a"
    substituteAll ${./tcpdirect.pc.in} $dev/lib/pkgconfig/tcpdirect-static.pc
    runHook postInstall
  '';

  postFixup = ''
    # zf_init from libonload_zf dynamically loads libefcp.so from openonload
    patchelf --add-rpath ${openonload.lib}/lib $lib/lib/libonload_zf.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Ultra low latency kernel bypass TCP and UDP implementation for AMD Solarflare network adapters";
    homepage = "https://www.openonload.org";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ YorikSar ];
    # ARM64 build fails, see https://github.com/Xilinx-CNS/onload/issues/253
    platforms = [ "x86_64-linux" ];
  };
}
