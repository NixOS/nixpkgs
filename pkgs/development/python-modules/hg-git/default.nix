{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aae1c47328bb7f928778712654c3d5f100445190e2891f175dac66d743fdb2e8";
  };

  propagatedBuildInputs = [ dulwich mercurial ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Only;
  };

}
