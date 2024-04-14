{ lib
, buildPerlPackage
, fetchFromGitHub
, makeWrapper
, openssh
, GitRepository
, URI
, XMLParser
}:

buildPerlPackage {
  pname = "ham-unstable";
  version = "2023-10-06";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "90d104ce481ee8f9b770be4b37d97f34eef5f82f";
    hash = "sha256-DeHH7k9K7CmQW6eOyf8TCV/HNYS30oFnI1b8ztBDk/o=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ openssh GitRepository URI XMLParser ];

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

  meta = with lib; {
    description = "A tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = "https://github.com/kernkonzept/ham";
    license = licenses.bsd2;
    maintainers = with maintainers; [ aw ];
    mainProgram = "ham";
    platforms = platforms.unix;
  };
}
