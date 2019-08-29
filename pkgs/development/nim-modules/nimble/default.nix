{ stdenv, fetchFromGitHub, makeWrapper, nim, openssl }:

stdenv.mkDerivation rec {
  pname = "nimble";
  version = "0.10.2";

  nativeBuildInputs = [ nim ];

  buildInputs = [ makeWrapper openssl ];

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "nimble";
    rev = "v" + version;
    sha256 = "1l292d1z9a5wrc1i58znlpxbqvh69pr0qdv9zvhq29lr9vnkx1a2";
  };

  patches = [ ./json.patch ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = [ "-lcrypto" ];

  buildPhase = ''
    runHook preBuild
    local HOME=$TMPDIR
    nim c -d:release --nilseqs:on -o:nimble src/nimble.nim
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    nimble test
    runHook postCheck
  '';

  # Wrap Nimble so it may find Nim and C compilers
  installPhase = ''
    runHook preInstall
    install -D nimble $out/bin/nimble
    wrapProgram $out/bin/nimble \
      --prefix PATH : ${stdenv.lib.makeBinPath [ nim stdenv.cc ]} \

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    inherit (nim.meta) homepage license platforms;
    description = "Package manager for the Nim programming language";
    maintainers = with maintainers; [ ehmry ];
  };
}
