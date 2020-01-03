{ stdenv, lib, fetchFromGitHub, fetchpatch, mcpp, bzip2, expat, openssl, db5
, darwin, libiconv, Security
, cpp11 ? false
}:

stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "05xympbns32aalgcfcpxwfd7bvg343f16xpg6jv5s335ski3cjy2";
  };

  buildInputs = [ mcpp bzip2 expat openssl db5 ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools libiconv Security ];

  postUnpack = ''
    sourceRoot=$sourceRoot/cpp
  '';

  prePatch = lib.optional stdenv.isDarwin ''
    substituteInPlace config/Make.rules.Darwin \
        --replace xcrun ""
  '';

  patches = [
    # Fixes compilation issues with GCC 8 using one of the patches
    # provided in https://github.com/zeroc-ice/ice/issues/82
    ( fetchpatch {
      url = "https://github.com/zeroc-ice/ice/commit/a6a4981616b669432ff7b588179d6e93694d9e3f.patch";
      sha256 = "17j5r7gsa3izrm7zln4mrp7l16h532gvmpas0kzglybicbiz7d56";
      stripLen = 1;
    })
  ];

  preBuild = ''
    makeFlagsArray+=(
      "prefix=$out"
      "OPTIMIZE=yes"
      "USR_DIR_INSTALL=yes"
      "CONFIGS=${if cpp11 then "cpp11-shared" else "shared"}"
      "SKIP=slice2py" # provided by a separate package
    )
  '';

  # cannot find -lIceXML (linking bin/transformdb)
  enableParallelBuilding = false;

  outputs = [ "out" "bin" "dev" ];

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/Ice-* $dev/share/ice
    rm -rf $out/share/slice
  '';

  meta = with stdenv.lib; {
    homepage = http://www.zeroc.com/ice.html;
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
