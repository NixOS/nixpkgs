{ lib
, stdenv
, fetchzip
, openjdk8
, makeWrapper
}:


stdenv.mkDerivation rec {
  pname = "kaitai-struct-compiler";
  version = "0.10";

  src = fetchzip {
    url = "https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/${version}/kaitai-struct-compiler-${version}.zip";
    sha256 = "sha256-oY1OiEq619kLmQPMRQ4sjuBnTXgJ2WfvsEj1JrxUGPA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D $src/bin/kaitai-struct-compiler $out/bin/kaitai-struct-compiler
    ln -s $out/bin/kaitai-struct-compiler $out/bin/ksc
    cp -R $src/lib $out/lib
    wrapProgram $out/bin/kaitai-struct-compiler --prefix PATH : ${lib.makeBinPath [ openjdk8 ] }
  '';

  meta = with lib; {
    homepage = "https://github.com/kaitai-io/kaitai_struct_compiler";
    description =
      "Compiler to generate binary data parsers in C++ / C# / Go / Java / JavaScript / Lua / Perl / PHP / Python / Ruby ";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ luis ];
    platforms = platforms.unix;
  };
}

