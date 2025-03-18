{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  django,
  django-stubs,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
  parameterized,
}:
let
  # 0.18.12 was yanked from PyPI, it refers to this issue:
  # https://github.com/deschler/django-modeltranslation/issues/701
  version = "0.19.6";
in
buildPythonPackage {
  pname = "django-modeltranslation";
  inherit version;

  src = fetchFromGitHub {
    owner = "deschler";
    repo = "django-modeltranslation";
    rev = "refs/tags/v${version}";
    hash = "sha256-zFY8YsM1Qp6rdcb+Upfk0/6mTv0o1zwxGqKzTupZ1zI=";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    django-stubs
    pytestCheckHook
    pytest-cov-stub
    pytest-django
    parameterized
  ];

  meta = with lib; {
    description = "Translates Django models using a registration approach";
    homepage = "https://github.com/deschler/django-modeltranslation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
