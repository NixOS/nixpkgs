{ lib, buildPythonPackage, fetchPypi, jinja2, inflect }:

buildPythonPackage rec {
  pname = "jinja2-pluralize";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "071wnzzz20wjb0iw7grxgj1lb2f0kz50qyfbcq54rddr2x82sp6z";
  };

  propagatedBuildInputs = [
    jinja2
    inflect
  ];

  meta = with lib; {
    description = "Jinja2 pluralize filters";
    homepage = "https://github.com/audreyr/jinja2-pluralize";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dzabraev ];
  };
}
