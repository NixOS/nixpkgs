{ stdenv, lib, fetchFromGitHub
, bzip2, expat, libedit, lmdb, openssl
, darwin, libiconv, Security
, python3 # for tests only
, cpp11 ? false
, fetchpatch
}:

let
  zeroc_mcpp = stdenv.mkDerivation rec {
    pname = "zeroc-mcpp";
    version = "2.7.2.14";

    src = fetchFromGitHub {
      owner = "zeroc-ice";
      repo = "mcpp";
      rev = "v${version}";
      sha256 = "1psryc2ql1cp91xd3f8jz84mdaqvwzkdq2pr96nwn03ds4cd88wh";
    };

    configureFlags = [ "--enable-mcpplib" ];
    installFlags = [ "PREFIX=$(out)" ];
  };

in stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.7.6";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "0zc8gmlzl2f38m1fj6pv2vm8ka7fkszd6hx2lb8gfv65vn3m4sk4";
  };

  patches = [
    # Fixes for openssl 3.0 / glibc-2.34.
    (fetchpatch {
      url = "https://github.com/zeroc-ice/ice/commit/7204b31a082a10cd481c1f31dbb6184ec699160d.patch";
      sha256 = "sha256-RN8kQrvWRu1oXB7UV7DkYbZ8A0VyJYGArx6ikovwefo=";
    })
    (fetchpatch {
      url = "https://github.com/zeroc-ice/ice/commit/358e7fea00383d55d1c19d38a3bbb64aca803aeb.patch";
      sha256 = "sha256-ntrTO6qHB7dw398BRdAyJQUfVYW3iEfzUaBYoWWOEDs=";
    })
  ];

  buildInputs = [ zeroc_mcpp bzip2 expat libedit lmdb openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools libiconv Security ];

  NIX_CFLAGS_COMPILE = "-Wno-error=class-memaccess -Wno-error=deprecated-copy";

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Make.rules.Darwin \
        --replace xcrun ""
  '';

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

  outputs = [ "out" "bin" "dev" ];

  doCheck = true;
  checkInputs = with python3.pkgs; [ passlib ];
  checkPhase = with lib; let
    # these tests require network access so we need to skip them.
    brokenTests = map escapeRegex [
      "Ice/udp" "Glacier2" "IceGrid/simple" "IceStorm" "IceDiscovery/simple"
    ];
    # matches CONFIGS flag in makeFlagsArray
    configFlag = optionalString cpp11 "--config=cpp11-shared";
  in ''
    runHook preCheck
    ${python3.interpreter} ./cpp/allTests.py ${configFlag} --rfilter='${concatStringsSep "|" brokenTests}'
    runHook postCheck
  '';

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/ice $dev/share
  '';

  meta = with lib; {
    homepage = "https://www.zeroc.com/ice.html";
    description = "The internet communications engine";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
