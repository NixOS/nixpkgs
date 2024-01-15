{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, django
, pytestCheckHook
, pytest-django
, parameterized
}:
let
  # 0.18.12 was yanked from PyPI, it refers to this issue:
  # https://github.com/deschler/django-modeltranslation/issues/701
  version = "0.18.12";
in
buildPythonPackage {
  pname = "django-modeltranslation";
  inherit version;

  src = fetchFromGitHub {
    owner = "deschler";
    repo = "django-modeltranslation";
    rev = "refs/tags/v${version}";
    hash = "sha256-6rAAu3Fd4D93rX8kvkcqhykzBu/lDByQ6zpjWq7J8mg=";
  };

  # Remove all references to pytest-cov
  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--no-cov-on-fail" "" \
      --replace "--cov-report=\"\"" "" \
      --replace "--cov modeltranslation" ""
  '';

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [ pytestCheckHook pytest-django parameterized ];

  meta = with lib; {
    description = "Translates Django models using a registration approach";
    homepage = "https://github.com/deschler/django-modeltranslation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
