{ lib
, fetchPypi
, buildPythonPackage
, cython
, ruamel-base
, ruamel-yaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-conda";
  version = "0.15.80";

  src = fetchPypi {
    inherit version;
    pname = "ruamel_yaml_conda";
    sha256 = "sha256-0NPzPfxACF5G3mcptkwnknVVBKiZ7xqy5VIz+ILflWY=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    ruamel-base
    ruamel-yaml
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ruamel-yaml-conda" ];

  meta = with lib; {
    description = ''
      YAML parser/emitter that supports roundtrip preservation of comments,
      seq/map flow style, and map key order
    '';
    homepage = "https://pypi.org/project/ruamel-yaml-conda";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
