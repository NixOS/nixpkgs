{ lib
, buildPerlPackage
, fetchFromGitHub
, makeWrapper
, openssh
, GitRepository
, URI
, XMLMini
}:

buildPerlPackage {
  pname = "ham-unstable";
  version = "2022-10-26";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "f2f10516177d00a79fe81701351632df2544ba4e";
    hash = "sha256-cxlZh1x8ycpZIwSeOwqB6BtwYaMoWtSPaeiyW41epdk=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ openssh GitRepository URI XMLMini ];

  preConfigure = ''
    patchShebangs .
    touch Makefile.PL
    rm -f Makefile
  '';

  installPhase = ''
    mkdir -p $out/lib $out/bin
    cp -r . $out/lib/ham

    makeWrapper $out/lib/ham/ham $out/bin/ham --argv0 ham \
      --prefix PATH : ${openssh}/bin
  '';

  doCheck = false;

  meta = with lib; {
    description = "A tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = "https://github.com/kernkonzept/ham";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aw ];
    mainProgram = "ham";
    platforms = platforms.unix;
  };
}
