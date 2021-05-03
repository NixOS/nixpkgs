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
  pname = "python-igraph";
  version = "0.9.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    rev = version;
    sha256 = "1ldyzza25zvwh144lw8x856z76s8gfvnbdm56fcmwkvm7aj81npw";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    igraph
    igraph.dev
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ MostAwesomeDude dotlambda ];
  };
}
