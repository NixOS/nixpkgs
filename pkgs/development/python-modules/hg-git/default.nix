{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-guJlIm9HPTgKw5cg/s7rFST/crAXfPxGYGeZxEJ+hcw=";
  };

  propagatedBuildInputs = [ dulwich mercurial ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Only;
  };

}
