{
  stdenv,
  lib,
  fetchFromGitHub,
  bzip2,
  expat,
  libedit,
  lmdb,
  mcpp,
  openssl,
  libxcrypt,
  python3, # for tests only
  cpp11 ? false,
}:

let
  mcpp' = mcpp.overrideAttrs (prevAttrs: rec {
    pname = "mcpp-zeroc-ice";
    version = "2.7.3";

    src = fetchFromGitHub {
      owner = "zeroc-ice";
      repo = "mcpp";
      rev = "v${version}";
      hash = "sha256-hZGU5mqMRTTHV2bR9uzM6ALj1sypjPxO5Ajg8aKzLxc=";
    };

    # zeroc-ice's fork diverges quite a bit from upstream mcpp, so prevAttrs.patches is not used here
    patches = [
      # See https://github.com/zeroc-ice/mcpp/pull/12
      ./fix-mb_init.patch
      ./fix-reserved-keywords.patch
    ];

    installFlags = prevAttrs.installFlags or [ ] ++ [ "PREFIX=$(out)" ];
  });
in
stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.7.10";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    hash = "sha256-l3cKsR8HSdtFGw1S12xueQOu/U9ABlOxQQtbHBj2izs=";
  };

  buildInputs = [
    mcpp'
    bzip2
    expat
    libedit
    lmdb
    openssl
    libxcrypt
  ];

  preBuild = ''
    makeFlagsArray+=(
      "prefix=$out"
      "OPTIMIZE=yes"
      "USR_DIR_INSTALL=yes"
      "LANGUAGES=cpp"
      "CONFIGS=${if cpp11 then "cpp11-shared" else "shared"}"
      "SKIP=slice2py" # provided by a separate package
    )
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  doCheck = true;
  nativeCheckInputs = with python3.pkgs; [ passlib ];
  checkPhase =
    let
      # these tests require network access so we need to skip them.
      brokenTests = map lib.escapeRegex [
        "Ice/udp"
        "Glacier2"
        "IceGrid/simple"
        "IceStorm"
        "IceDiscovery/simple"

        # FIXME: certificate expired, remove for next release?
        "IceSSL/configuration"
      ];
      # matches CONFIGS flag in makeFlagsArray
      configFlag = lib.optionalString cpp11 "--config=cpp11-shared";
    in
    ''
      runHook preCheck
      ${python3.interpreter} ./cpp/allTests.py ${configFlag} --rfilter='${lib.concatStringsSep "|" brokenTests}'
      runHook postCheck
    '';

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/ice $dev/share
  '';

  meta = {
    homepage = "https://www.zeroc.com/ice.html";
    description = "Internet communications engine";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
