{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, inflect
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jinja2-pluralize";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "jinja2_pluralize";
    inherit version;
    hash = "sha256-31wtUBe5tUwKZst5DMqfwIlFg3w9v8MjWJID8f+3PBw=";
  };

  propagatedBuildInputs = [
    jinja2
    inflect
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jinja2_pluralize"
  ];

  meta = with lib; {
    description = "Jinja2 pluralize filters";
    homepage = "https://github.com/audreyr/jinja2_pluralize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dzabraev ];
  };
}
