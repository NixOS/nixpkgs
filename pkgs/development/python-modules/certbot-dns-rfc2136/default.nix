{
  buildPythonPackage,
  acme,
  certbot,
  dnspython,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "certbot-dns-rfc2136";
  format = "setuptools";

  inherit (certbot) src version;

  sourceRoot = "${finalAttrs.src.name}/certbot-dns-rfc2136";

  propagatedBuildInputs = [
    acme
    certbot
    dnspython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-pno:cacheprovider"

    # Monitor https://github.com/certbot/certbot/issues/9606 for a solution
    "-Wignore::DeprecationWarning"
  ];

  meta = certbot.meta // {
    description = "RFC 2136 DNS Authenticator plugin for Certbot";
  };
})
