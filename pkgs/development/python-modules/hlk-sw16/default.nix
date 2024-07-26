{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "hlk-sw16";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jameshilliard";
    repo = "hlk-sw16";
    rev = version;
    sha256 = "010s85nr6xn89i8yvdagg72a97dh1v2pyfqa33v76p9p8xbgh8dz";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "hlk_sw16" ];

  meta = with lib; {
    description = "Python client for HLK-SW16";
    homepage = "https://github.com/jameshilliard/hlk-sw16";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
