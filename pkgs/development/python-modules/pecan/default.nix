{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, isPy27
# Python deps
, logutils
, Mako
, singledispatch ? null
, six
, webtest
# Test Inputs
, pytestCheckHook
, genshi
, gunicorn
, jinja2
, Kajiki
, mock
, sqlalchemy
, virtualenv
}:

buildPythonPackage rec {
  pname = "pecan";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b2acd6802a04b59e306d0a6ccf37701d24376f4dc044bbbafba3afdf9d3389a";
  };

  patches = [
    (fetchpatch {
      name = "Support-SQLAlchemy-1.4x.patch";
      url = "https://github.com/pecan/pecan/commit/a520bd544c0b02a02dbf692b8d6e2f7a503ee6d4.patch";
      sha256 = "sha256-QCHRjwnpy8ndCvcuyE5Y65BybKYthJXDySUtmpJD8gY=";
    })
  ];

  propagatedBuildInputs = [
    logutils
    Mako
    singledispatch
    six
    webtest
  ];

  checkInputs = [
    pytestCheckHook
    genshi
    gunicorn
    jinja2
    mock
    sqlalchemy
    virtualenv
  ] ++ lib.optionals isPy27 [ Kajiki ];

  pytestFlagsArray = [
    "--pyargs pecan "
  ];

  meta = with lib; {
    description = "WSGI object-dispatching web framework, designed to be lean and fast";
    homepage = "https://www.pecanpy.org/";
    changelog = "https://pecan.readthedocs.io/en/latest/changes.html";
    maintainers = with maintainers; [ applePrincess ];
  };
}
