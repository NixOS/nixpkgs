{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  black,
  flake8,
  isort,
}:

buildPythonPackage rec {
  pname = "red-commons";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Red-Commons";
    inherit version;
    hash = "sha256-ubzFXHKAHDPrDHeq9IBB0Bi/tfEpMFPP+KPhDk0z5S0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  passthru.optional-dependencies = {
    dev = [
      black
      flake8
      isort
    ];
  };

  pythonImportsCheck = [ "red_commons" ];

  meta = with lib; {
    description = "Common utilities used by multiple projects maintained by Cog Creators";
    homepage = "https://pypi.org/project/Red-Commons/";
    license = licenses.mit;
    maintainers = with maintainers; [ laggron42 ];
  };
}
