{
  lib,
  buildPythonPackage,
  cacert,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2025.07.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "certifi";
    repo = "python-certifi";
    rev = version;
    hash = "sha256-TSqBca42i7i59ERTrnPN0fLdLWToYMCq5cfFFsgZm5U=";
  };

  patches = [
    # Add support for NIX_SSL_CERT_FILE
    ./env.patch
  ];

  postPatch = ''
    # Use our system-wide ca-bundle instead of the bundled one
    rm -v "certifi/cacert.pem"
    ln -snvf "${cacert}/etc/ssl/certs/ca-bundle.crt" "certifi/cacert.pem"
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedNativeBuildInputs = [
    # propagate cacerts setup-hook to set up `NIX_SSL_CERT_FILE`
    cacert
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "certifi" ];

  meta = with lib; {
    homepage = "https://github.com/certifi/python-certifi";
    description = "Python package for providing Mozilla's CA Bundle";
    license = licenses.isc;
    maintainers = with maintainers; [ koral ];
  };
}
