{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, isPy3k
, fetchpatch
, brotli
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wbnhvn0c9w1hg0ykkqh7vqzr48sfgh33na6j08fqir86a6bvb3p";
  };

  propagatedBuildInputs = [ dulwich brotli ];

  # circular dependency, tests need mercurial to be installed, but hg-git is a
  # dependency of nixpkgs' mercurial package.
  doCheck = false;

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "http://hg-git.github.com/";
    maintainers = with maintainers; [ koral holgerpeters ];
    license = lib.licenses.gpl2Only;
  };
}
