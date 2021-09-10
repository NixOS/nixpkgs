{ lib
, fetchPypi
, buildPythonPackage
, wrapt
, pytest
}:

buildPythonPackage rec {
  pname = "Deprecated";
  version = "1.2.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Q6xTNdqQwxwkugKK9TapHUHVP55pAd2wIbzFcs5E440=";
  };

  propagatedBuildInputs = [ wrapt ];
  checkInputs = [ pytest ];
  meta = with lib; {
    homepage = "https://github.com/tantale/deprecated";
    description = "Python @deprecated decorator to deprecate old python classes, functions or methods";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ tilpner ];
  };
}
