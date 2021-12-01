{ lib, buildPythonPackage, fetchFromGitHub
, click }:

buildPythonPackage rec {
  pname = "click-datetime";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "click-contrib";
    repo = pname;
    rev = version;
    sha256 = "1yxagk4wd2h77nxml19bn2y26fv2xw2n9g981ls8mjy0g51ms3gh";
  };

  propagatedBuildInputs = [ click ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "click_datetime" ];

  meta = with lib; {
    description = "Datetime type support for click.";
    homepage = "https://github.com/click-contrib/click-datetime";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
