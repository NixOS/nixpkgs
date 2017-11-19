{ lib
, python
, buildPythonPackage
, fetchPypi
, alembic
, ipython
, jinja2
, python-oauth2
, pamela
, sqlalchemy
, tornado
, traitlets
, requests
, nodejs-8_x
}:

buildPythonPackage rec {
  pname = "jupyterhub";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "100cf18d539802807a45450d38fefbb376cf1c810f3b1b31be31638829a5c69c";
  };

  preBuild = "mkdir .home; HOME=$PWD/.home";
  
  buildInputs =
    [
      requests
      nodejs-8_x
    ];

  propagatedBuildInputs =
    [
      alembic
      ipython
      jinja2
      python-oauth2
      pamela
      sqlalchemy
      tornado
      traitlets
    ];

  doCheck = false;
      
  meta = with lib; {
    description = "Serves multiple Jupyter notebook instances";
    homepage = http://jupyter.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
