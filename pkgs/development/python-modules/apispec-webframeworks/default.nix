{ lib
, buildPythonPackage
, fetchFromGitHub
, apispec
, pytestCheckHook
, mock
, flask
, tornado
, bottle
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "apispec-webframeworks";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    sha256 = "0jdyqa78681208k6pxs7j0sbiwjv0bklysyjqgixkxyf2ac6c8q7";
  };

  propagatedBuildInputs = [
    apispec
  ];

  checkInputs = [
    pytestCheckHook
    mock
    flask
    tornado
    bottle
  ];

  pythonImportsCheck = [
    "apispec_webframeworks.flask"
  ];

  meta = with lib; {
    description = "Web framework plugins for apispec";
    homepage = "https://github.com/marshmallow-code/apispec-webframeworks";
    license = licenses.mit;
    maintainers = with maintainers; [ glittershark ];
  };
}
