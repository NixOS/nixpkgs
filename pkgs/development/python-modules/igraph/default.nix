{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pkg-config
, igraph
, texttable
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "igraph";
<<<<<<< HEAD
  version = "0.10.8";
=======
  version = "0.10.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-EpWkFKN8fhKkzR2g9Uv0/LxSwi4TkraH5rjde7yR+C8=";
=======
    hash = "sha256-DR4D12J/BKFpF4hMHfitNmwDZ7UEo+pI0tvEa1T5GTY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    rm -r vendor
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    igraph
  ];

  propagatedBuildInputs = [
    texttable
  ];

  # NB: We want to use our igraph, not vendored igraph, but even with
  # pkg-config on the PATH, their custom setup.py still needs to be explicitly
  # told to do it. ~ C.
  setupPyGlobalFlags = [ "--use-pkg-config" ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "igraph" ];

  meta = with lib; {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    changelog = "https://github.com/igraph/python-igraph/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MostAwesomeDude dotlambda ];
  };
}
