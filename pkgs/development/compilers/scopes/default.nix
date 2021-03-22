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
  version = "unstable-2019-06-13";

  src = fetchFromBitbucket {
    owner = "duangle";
    repo = "scopes";
    rev = "bd29af1";
    sha256 = "0czhww3mpznapqv9y2sy3ilfzd7q9580scmlvdjz357fkvyr4pra";
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
    (fetchpatch {
        url = https://bitbucket.org/jacereda/scopes/commits/94d8f2ac1f6c3415d6ae4e319cf7ea91378e25ee/raw;
        sha256 = "1ikimqz52ndf5gvby3s20z6ljvjg7cqz0f342cccwq16l3lyxnk5";
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
