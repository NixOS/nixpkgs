{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "whisper";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "refresh-bio";
    repo = "whisper";
    rev = "v${version}";
    sha256 = "0wpx1w1mar2d6zq2v14vy6nn896ds1n3zshxhhrrj5d528504iyw";
  };

  patches = [
    # gcc-13 compatibility fixes:
    #   https://github.com/refresh-bio/Whisper/pull/17
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/refresh-bio/Whisper/commit/d67e110dd6899782e4687188f6b432494315b0b4.patch";
      hash = "sha256-Z8GrkUMIKO/ccEdwulQh+WUox3CEckr6NgoBSzYvfuw=";
    })
  ];

  preConfigure = ''
    cd src

    # disable default static linking
    sed -i 's/ -static / /' makefile
  '';

  enableParallelBuilding = true;

  # The package comes with prebuilt static
  # libraries of bzip2, zlib, libdeflate and asmlib.
  # They are not built with -fPIE and thus linking fails.
  # As asmlib is not packages in nixpkgs let's disable PIE.
  env.NIX_LDFLAGS = "-no-pie";

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin whisper whisper-index
    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Short read sequence mapper";
    license = licenses.gpl3;
    # vendored libraries acof, aelf, deflate, bzip2, zlib
    # https://github.com/refresh-bio/Whisper/issues/18
    knownVulnerabilities = [
      # src/libs/libz.a from 2017
      "CVE-2018-25032"
      "CVE-2022-37434"
      # src/libs/libbzip2.lib
      "CVE-2019-12900"
    ];
    homepage = "https://github.com/refresh-bio/whisper";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
