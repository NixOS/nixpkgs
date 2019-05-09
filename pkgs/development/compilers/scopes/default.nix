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
    rev = "3c5fd78";
    sha256 = "1im9lm0j4j4d797mwn97zfsfh91rls1arw52filzdi3wlq4zgxfi";
  };

  nativeBuildInputs = [ genie spirv-tools spirv-cross ];

  buildInputs = [ llvm clang-unwrapped ];

  patches = [
    (fetchpatch {
      url = https://bitbucket.org/jacereda/scopes/commits/8fc13cdd237565fccc0a6c73edbefbf634ffd555/raw;
      sha256 = "0g3qsgjcilcr41x0rliccrbimric2pffax85vc46acs4sz4k51ci";
    })
    (fetchpatch {
      url = https://bitbucket.org/jacereda/scopes/commits/8b05b40e2f2fbf0a670eb40028f71d47da720fe2/raw;
      sha256 = "0x2chlw3z5i0mrd85qbmbbhclh9j7xhy55a0igrzvhmcyx2yaqd8";
    })
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
