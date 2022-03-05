{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27e6d7686a1548d4632dcc977f2ff3ce2e42d80735339b1f3b389b7481260cc4";
  };

  propagatedBuildInputs = [ dulwich mercurial ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Only;
  };

}
