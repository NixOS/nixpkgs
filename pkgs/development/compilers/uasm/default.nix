{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "uasm";
  version = "2.55";

  src = fetchFromGitHub {
    owner = "Terraspace";
    repo = pname;
    # Specifying only the tag results in the following error during download:
    # the given path has multiple possibilities: #<Git::Ref:0x00007f618689c378>, #<Git::Ref:0x00007f618689c1e8>
    # Probably because upstream has both a tag and a branch with the same name
    rev = "refs/tags/v${version}";
    sha256 = "sha256-CIbHPKJa60SyJeFgF1Tux7RfJZBChhUVXR7HGa+gCtQ=";
  };

  enableParallelBuilding = true;

  makefile = "gccLinux64.mak";

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" -m0755 GccUnixR/uasm
    install -Dt "$out/share/doc/${pname}" -m0644 {Readme,History}.txt Doc/*

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.terraspace.co.uk/uasm.html";
    description = "A free MASM-compatible assembler based on JWasm";
    platforms = platforms.linux;
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.watcom;
  };
}
