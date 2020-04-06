{ lib, buildPerlPackage, fetchFromGitHub, makeWrapper, openssh, GitRepository, URI, XMLMini }:

buildPerlPackage {
  pname = "ham-unstable";
  version = "2019-01-22";

  src = fetchFromGitHub {
    owner = "kernkonzept";
    repo = "ham";
    rev = "37c2e4e8b8bd779ba0f8c48a3c6ba34bad860b92";
    sha256 = "0h5r5256niskypl4g1j2573wqi0nn0mai5p04zsa06xrgyjqcy2j";
  };

  outputs = [ "out" ];

  buildInputs = [ makeWrapper ];
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

  meta = {
    description = "A tool to manage big projects consisting of multiple loosely-coupled git repositories";
    homepage = https://github.com/kernkonzept/ham;
    license = "unknown"; # should be gpl2, but not quite sure
    maintainers = with lib.maintainers; [ aw ];
    platforms = lib.platforms.unix;
  };
}
