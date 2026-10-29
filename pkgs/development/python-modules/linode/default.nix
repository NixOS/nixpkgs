{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "linode";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2zwqf6uJZtkDpj8WxRW/8kFTPk7y10aqeq5KSbul5XM=";
  };

  propagatedBuildInputs = [ requests ];

  meta = {
    homepage = "https://github.com/ghickman/linode";
    description = "Thin python wrapper around Linode's API";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
