{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "jinja2-ansible-filters";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B8EM9E1wc/TwEQLKEtmi3DG0HUfkxh7ZLvam0mabNWs=";
  };

  propagatedBuildInputs = [
    jinja2
    pyyaml
  ];

  # no tests include in sdist, and source not available
  doCheck = false;

  pythonImportsCheck = [ "jinja2_ansible_filters" ];

  meta = with lib; {
    description = "Jinja2 Ansible Filters";
    homepage = "https://pypi.org/project/jinja2-ansible-filters/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
