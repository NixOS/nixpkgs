{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, mercurial
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ORGDOWLrnImca+qPtJZmyC8hGxJNCEC+tq2V4jpGIbY=";
  };

  propagatedBuildInputs = [ dulwich mercurial ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Only;
  };

}
