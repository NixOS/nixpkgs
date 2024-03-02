{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, hatch-jupyter-builder
, hatchling
, importlib-metadata
, ipywidgets
, psygnal
, typing-extensions
, watchfiles
}:

buildPythonPackage rec {
  pname = "anywidget";
  version = "0.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S6nB3Df17sD1Zrsp+1Di66FNeaVmE1rqt8hogjI/3I4=";
  };

  # We do not need the jupyterlab build dependency, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab==3.*"' ""
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
  ];

  propagatedBuildInputs = [
    ipywidgets
    psygnal
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    watchfiles
  ];

  pythonImportsCheck = [ "anywidget" ];

  meta = with lib; {
    description = "Custom jupyter widgets made easy";
    homepage = "https://github.com/manzt/anywidget";
    changelog = "https://github.com/manzt/anywidget/releases/tag/anywidget%40${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
