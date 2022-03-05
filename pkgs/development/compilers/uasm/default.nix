{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "uasm";
  version = "2.53";

  src = fetchFromGitHub {
    owner = "Terraspace";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Aohwrcb/KTKUFFpfmqVDPNjJh1dMYSNnBJ2eFaP20pM=";
  };

  # https://github.com/Terraspace/UASM/pull/154
  patches = [
    # fix `invalid operands to binary - (have 'char *' and 'uint_8 *' {aka 'unsigned char *'})`
    (fetchpatch {
      name = "fix_pointers_compare.patch";
      url = "https://github.com/clouds56/UASM/commit/9cd3a400990e230571e06d4c758bd3bd35f90ab6.patch";
      sha256 = "sha256-8mY36dn+g2QNJ1JbWt/y4p0Ha9RSABnOE3vlWANuhsA=";
    })
    # fix `dbgcv.c:*:*: fatal error: direct.h: No such file or directory`
    (fetchpatch {
      name = "fix_build_dbgcv_c_on_unix.patch";
      url = "https://github.com/clouds56/UASM/commit/806d54cf778246c96dcbe61a4649bf0aebcb0eba.patch";
      sha256 = "sha256-uc1LaizdYEh1Ry55Cq+6wrCa1OeBPFo74H5iBpmteAE=";
    })
  ];

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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ thiagokokada ];
    license = licenses.watcom;
  };
}
