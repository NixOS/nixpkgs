{ stdenv, lib, fetchFromGitHub, mcpp, bzip2, expat, openssl, lmdb
, darwin, libiconv, Security
, cpp11 ? false
}:

let
  zeroc_mcpp = mcpp.overrideAttrs (self: rec {
    pname = "zeroc-mcpp";
    version = "2.7.2.14";

    src = fetchFromGitHub {
      owner = "zeroc-ice";
      repo = "mcpp";
      rev = "v${version}";
      sha256 = "1psryc2ql1cp91xd3f8jz84mdaqvwzkdq2pr96nwn03ds4cd88wh";
    };

    installFlags = [ "PREFIX=$(out)" ];
  });

in stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "0m9lh79dfpcwcp2jhmj0wqdcsw3rl633x2hzfw9n2i34jjv64fvg";
  };

  buildInputs = [ zeroc_mcpp bzip2 expat openssl lmdb ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools libiconv Security ];

  NIX_CFLAGS_COMPILE = "-Wno-error=class-memaccess -Wno-error=deprecated-copy";

  prePatch = lib.optional stdenv.isDarwin ''
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

  buildFlags = [ "srcs" ]; # no tests; they require network

  enableParallelBuilding = true;

  outputs = [ "out" "bin" "dev" ];

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/ice $dev/share
  '';

  meta = with stdenv.lib; {
    homepage = http://www.zeroc.com/ice.html;
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
