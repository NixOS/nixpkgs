{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pydantic,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-pydantic-field";
  version = "v0.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "surenkov";
    repo = pname;
    rev = version;
    hash = "sha256-rlnS67OGljWD8Sbyutb43txAH0jA2+8ju1ntSEP3whM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    django
    pydantic
  ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/${src.owner}/${pname}";
    maintainers = with lib.maintainers; [ kiara ];
    license = licenses.mit;
  };
}
