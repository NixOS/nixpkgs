{ stdenv
, substituteAll
, fetchFromBitbucket
, fetchpatch
, llvm
, clang
, clang-unwrapped
, genie
, spirv-tools
, spirv-cross
, libch
, clangh
}:
stdenv.mkDerivation rec {
  pname = "scopes";
  version = "unstable-2019-05-09";

  src = fetchFromBitbucket {
    owner = "duangle";
    repo = "scopes";
    rev = "6f44049";
    sha256 = "1dhvfyj2clkqj1mw83dfzwiqmarfsaj20znrrq6rl15882xw3y2r";
  };

  nativeBuildInputs = [ genie spirv-tools spirv-cross ];

  buildInputs = [ llvm clang-unwrapped ];

  patches = [
    (substituteAll {
      name = "nixpkgs-patches.patch";
      src = fetchpatch {
        url = https://bitbucket.org/jacereda/scopes/commits/45eb6d3dca6b361da19736a42e02d4317032ef8d/raw;
        sha256 = "1h94n92b6biacbvni2ygqcpdyc8sqr4w3mk7clyijkbhziriphkh";
      };
      inherit clang llvm clangh libch;
    })
  ];

  makefile = "Makefile";

  makeFlags = "-C build config=release";

  installPhase = ''
    install -d $out/bin
    install -d $out/lib
    cp bin/scopes $out/bin
    cp bin/lib* $out/lib
    cp -R lib/* $out/lib/
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -change @executable_path/libscopesrt.dylib $out/lib/libscopesrt.dylib $out/bin/scopes
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    export HOME=$TMPDIR
    $out/bin/scopes testing/test_all.sc
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Retargetable programming language & infrastructure";
    homepage = http://scopes.rocks;
    license = stdenv.lib.licenses.mit;
  };
}
