{ stdenv, fetchFromGitHub, cmake, clang, python, v8_static, coreutils }:

let
  sexpr_wasm_prototype = stdenv.mkDerivation {
    name = "sexpr_wasm_prototype";
    src = fetchFromGitHub {
      owner = "WebAssembly";
      repo = "sexpr-wasm-prototype";
      rev = "1347a367c34876bfe92562f244a8c8b770372479";
      sha256 = "1v1mph5fp1rffhvh8bbx937gpjqjrdgm7yhffdxzdn4pih9d0grn";
    };

    configurePhase = ''
      # set this to nonempty string to disable default cmake configure
    '';

    buildInputs = [ cmake clang python ];

    buildPhase = "make clang-debug-no-tests";

    hardeningDisable = [ "format" ];

    installPhase = ''
      mkdir -p $out/bin
      cp out/clang/Debug/no-tests/sexpr-wasm $out/bin
    '';
  };

in

stdenv.mkDerivation {
  name = "wasm-0.0.1";

  src = fetchFromGitHub {
    owner = "proglodyte";
    repo = "wasm";
    rev = "650188eecaaf4b64f12b341986b4e89e5fdb3bbe";
    sha256 = "1f5mdl0l2448lx7h36b4bdr541a4q1wapn1kdwrd4z7s94n7a5gq";
  };

  configurePhase = ''
    sed -i -e "s|sudo ||g" Makefile
  '';

  installPhase = ''
    export DESTDIR=$out
    export MKTEMPDIR=${coreutils}/bin
    export D8DIR=${v8_static}/bin
    export SWDIR=${sexpr_wasm_prototype}/bin
    make install
  '';

  meta = with stdenv.lib; {
    description = "wasm runs WebAssembly from the command line";
    maintainers = with maintainers; [ proglodyte ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
