{ stdenv, fetchgit, coq, mathcomp }:

stdenv.mkDerivation rec {

  name = "coq-autosubst-${coq.coq-version}-${version}";
  version = "5b40a32e";

  src = fetchgit {
    url = git://github.com/uds-psl/autosubst.git;
    rev = "1c3bb3bbf5477e3b33533a0fc090399f45fe3034";
    sha256 = "06pcjbngzwqyncvfwzz88j33wvdj9kizxyg5adp7y6186h8an341";
  };

  propagatedBuildInputs = [ mathcomp ];

  patches = [./0001-changes-to-work-with-Coq-8.6.patch];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://www.ps.uni-saarland.de/autosubst/;
    description = "Automation for de Bruijn syntax and substitution in Coq";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = { inherit (mathcomp) compatibleCoqVersions; };

}
