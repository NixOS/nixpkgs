{
  lib,
  buildPythonPackage,
  fetchzip,
  mkdocs,
  setuptools,
}:

buildPythonPackage {
  pname = "mkdocs-gitlab-plugin";
  version = "0.1.4";
  pyproject = true;

  src = fetchzip {
    url = "https://gitlab.inria.fr/vidjil/mkdocs-gitlab-plugin/-/archive/fb87fbfd404839e661a799c540664b1103096a5f/mkdocs-gitlab-plugin-fb87fbfd404839e661a799c540664b1103096a5f.tar.gz";
    hash = "sha256-z+U0PRwymDDXVNM7a2Yl4pNNVBxpx/BhJnlx6kgyvww=";
  };

  patches = [ ./mkdocs-gitlab-plugin.diff ];

  build-system = [ setuptools ];

  dependencies = [ mkdocs ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "mkdocs_gitlab_plugin" ];

  meta = with lib; {
    description = "MkDocs plugin to transform strings into links to a Gitlab repository";
    longDescription = ''
      Transform handles such as #1234, %56, !789, &12 or $34 into links to a gitlab repository,
      given by the gitlab_url configuration option.
      Before the #/%/!/&/$ is needed either a space, a '(', or a '['.
    '';
    homepage = "https://gitlab.inria.fr/vidjil/mkdocs-gitlab-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
