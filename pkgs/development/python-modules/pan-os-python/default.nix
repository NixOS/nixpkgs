{
  lib,
  buildPythonPackage,
  fetchPypi,
  pan-python,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pan-os-python";
  version = "1.13.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pan_os_python";
    inherit version;
    hash = "sha256-psA/8HV0m+2qoKKXlF5VQ1vJ7JJrCWcaaDCfT6g+zFk=";
  };

  postPatch = ''
    # Modernize project definition
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api' \
      --replace-fail 'poetry>=0.12' 'poetry-core' \
      --replace-fail 'pan-python = "^0.17.0"' 'pan-python = "^0.25.0"'
  '';

  dependencies = [ pan-python ];

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
