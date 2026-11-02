{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  argcomplete,
  cccolutils,
  gitpython,
  koji,
  pycurl,
  pyyaml,
  requests,
  rpm,
  six,
}:

buildPythonPackage rec {
  pname = "rpkg";
  version = "1.69";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F+EgJJYeIONhz9dn1UsQPzgAmQTo4dqXzPxFFDXNT8s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    argcomplete
    cccolutils
    gitpython
    koji
    pycurl
    pyyaml
    requests
    rpm
    six
  ];

  # bin/rpkg is shipped as a plain script.
  postInstall = ''
    install -Dm755 bin/rpkg $out/bin/rpkg
  '';

  pythonImportsCheck = [ "pyrpkg" ];

  meta = {
    description = "Python library and script for managing RPM package sources in a git repository";
    homepage = "https://pagure.io/rpkg";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "rpkg";
  };
}
