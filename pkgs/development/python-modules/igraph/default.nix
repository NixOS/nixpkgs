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
  version = "0.11.3";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = "python-igraph";
    rev = "refs/tags/${version}";
    hash = "sha256-Pki0ygcQeuC5E4SwhzGX7oIe9LUSgoBKiXbtcpjL3ng=";
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
