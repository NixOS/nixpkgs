{ lib
, buildPythonPackage
, fetchFromGitHub
, libsass
, six
, pytestCheckHook
, werkzeug
}:

buildPythonPackage rec {
  pname = "libsass";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    rev = version;
    sha256 = "sha256-4doz3kkRlyfVfeUarYw2tcybeDVeE2jpgmHxFJsPiVc=";
  };

  buildInputs = [ libsass ];

  propagatedBuildInputs = [ six ];

  preBuild = ''
    export SYSTEM_SASS=true;
  '';

  checkInputs = [
    pytestCheckHook
    werkzeug
  ];

  pytestFlagsArray = [ "sasstests.py" ];

  pythonImportsCheck = [ "sass" ];

  meta = with lib; {
    description = "Python binding for libsass to compile Sass/SCSS";
    homepage = "https://sass.github.io/libsass-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
