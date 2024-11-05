{
  lib,
  buildPythonPackage,
  cached-property,
  click,
  fetchFromGitHub,
  packaging,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pythonfinder";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "pythonfinder";
    rev = "refs/tags/${version}";
    hash = "sha256-CbaKXD7Sde8euRqvc/IHoXoSMF+dNd7vT9LkLWq4/IU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ packaging ] ++ lib.optionals (pythonOlder "3.8") [ cached-property ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pythonfinder" ];

  meta = with lib; {
    description = "Cross platform search tool for finding Python";
    mainProgram = "pyfinder";
    homepage = "https://github.com/sarugaku/pythonfinder";
    changelog = "https://github.com/sarugaku/pythonfinder/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
