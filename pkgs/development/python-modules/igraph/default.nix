{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pkg-config
, igraph
, texttable
, python
}:

buildPythonPackage rec {
  pname = "igraph";
  version = "0.9.11";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    rev = version;
    hash = "sha256-tvkV5ve9X+LXx3LOdHIPljQKZc1v6yts0juo4SwDmfY=";
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

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "igraph" ];

  meta = with lib; {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    changelog = "https://github.com/igraph/python-igraph/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MostAwesomeDude dotlambda ];
  };
}
