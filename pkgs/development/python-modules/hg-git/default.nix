{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, brotli
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wbnhvn0c9w1hg0ykkqh7vqzr48sfgh33na6j08fqir86a6bvb3p";
  };

  propagatedBuildInputs = [ dulwich brotli ];

  checkInputs = [ mercurial ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io";
    maintainers = with maintainers; [ koral holgerpeters ];
    license = licenses.gpl2Only;
  };
}
