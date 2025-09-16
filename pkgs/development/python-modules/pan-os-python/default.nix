{
  lib,
  buildPythonPackage,
  fetchPypi,
  packaging,
  pan-python,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pan-os-python";
  version = "1.12.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pan_os_python";
    inherit version;
    hash = "sha256-b3jHu//GX031UbApDzYjCUXpI5MOdHwk9mXVymsFttk=";
  };

  postPatch = ''
    # Modernize project definition
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api' \
      --replace-fail 'poetry>=0.12' 'poetry-core' \
      --replace-fail 'pan-python = "^0.17.0"' 'pan-python = "^0.25.0"'
    substituteInPlace panos/__init__.py \
      --replace-fail "from distutils.version import LooseVersion" "from packaging.version import Version as LooseVersion"
  '';

  dependencies = [
    packaging
    pan-python
  ];

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "panos" ];

  meta = {
    description = "Palo Alto Networks PAN-OS SDK for Python";
    homepage = "https://github.com/PaloAltoNetworks/pan-os-python";
    changelog = "https://github.com/PaloAltoNetworks/pan-os-python/releases/tag/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
