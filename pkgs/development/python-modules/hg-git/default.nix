{ lib
, buildPythonPackage
, fetchPypi
, dulwich
, mercurial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hg-git";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ORGDOWLrnImca+qPtJZmyC8hGxJNCEC+tq2V4jpGIbY=";
  };

  propagatedBuildInputs = [
    dulwich
    mercurial
  ];

  pythonImportsCheck = [
    "hggit"
  ];

  meta = with lib; {
    description = "Push and pull from a Git server using Mercurial";
    homepage = "https://hg-git.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ koral ];
  };
}
