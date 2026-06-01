{
  lib,
  buildPythonPackage,
  fetchPypi,
  marshmallow,
  requests,
  requests-toolbelt,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "netapp-ontap";
  version = "9.17.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "netapp_ontap";
    inherit version;
    hash = "sha256-bzDGsKCEH3oszuz4OKnOg7WTMQTnJAGh7POmGhRCyzc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'marshmallow>=3.21.3,<4.0.0' 'marshmallow>=3.21.3'
  '';

  build-system = [ setuptools ];

  dependencies = [
    marshmallow
    requests
    requests-toolbelt
    urllib3
  ];

  # No tests in sdist and no other download available
  doCheck = false;

  pythonImportsCheck = [ "netapp_ontap" ];

  meta = {
    description = "Library for working with ONTAP's REST APIs simply in Python";
    homepage = "https://library.netapp.com/ecmdocs/ECMLP3331665/html/index.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "ontap-cli";
  };
}
