{
  lib,
  buildPythonPackage,
  cacert,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "certifi";
  version = "2026.10.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "certifi";
    repo = "python-certifi";
    tag = finalAttrs.version;
    hash = "sha256-uESJgC07To+bUePmwi180SCtAzAZkmEn1UolTWpB4X0=";
  };

  # Use NIX_SSL_CERT_FILE or the system CA bundle
  postPatch = ''
    rm -v certifi/{core.py,cacert.pem}
    cp "${./core.py}" "certifi/core.py"
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    cacert
    pytestCheckHook
  ];

  pythonImportsCheck = [ "certifi" ];

  meta = {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
})
