{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "mirumee";
    repo = "google-i18n-address";
    rev = "refs/tags/${version}";
    sha256 = "sha256-7t5sNpEVajdwcW8+xTNZQKZVgxhUzfbVbEVgn7JJ2MY=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "i18naddress" ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.bsd3;
  };
}
