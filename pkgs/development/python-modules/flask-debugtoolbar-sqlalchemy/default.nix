{
  lib,
  buildPythonPackage,
  fetchFromSourcehut,
  setuptools,
  flask-debugtoolbar,
  sqlalchemy,
  sqlparse,
  pygments,
}:

buildPythonPackage (finalAttrs: {
  pname = "flask-debugtoolbar-sqlalchemy";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromSourcehut {
    owner = "~ihabunek";
    repo = "flask_debugtoolbar_sqlalchemy";
    rev = finalAttrs.version;
    hash = "sha256-Oxe2ircmVtd5IAibsK3mAVS1KM13coSNFzm0Xuft3VQ=";
  };

  postPatch = ''
    sed -i "s/version = subprocess.*/version = '0.2.0'/g" setup.py
    sed -i "/stdout=subprocess.PIPE/d" setup.py
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    flask-debugtoolbar
    sqlalchemy
    sqlparse
    pygments
  ];

  pythonImportsCheck = [ "flask_debugtoolbar_sqlalchemy" ];

  doCheck = false; # no tests directory

  meta = {
    description = "SQLAlchemy panel for the Flask Debug Toolbar";
    longDescription = ''
      Flask Debug Toolbar panel for SQLAlchemy. It adds a database tab to the debug toolbar.
    '';
    homepage = "https://git.sr.ht/~ihabunek/flask_debugtoolbar_sqlalchemy";
    changelog = "https://git.sr.ht/~ihabunek/flask_debugtoolbar_sqlalchemy/tree/${finalAttrs.version}/item/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
