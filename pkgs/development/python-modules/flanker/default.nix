{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  chardet,
  cryptography,
  idna,
  ply,
  regex,
  six,
  standard-imghdr,
  tld,
  webob,
}:

buildPythonPackage (finalAttrs: {
  pname = "flanker";
  version = "0.9.11";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mailgun";
    repo = "flanker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ThmfHgl8LbgDRUINen4JvOo6f7n5VJ+ULjaENCvfZvg=";
  };

  patches = [
    ./qualify-parsetab-imports.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    chardet
    cryptography
    idna
    ply
    regex
    six
    standard-imghdr
    tld
    webob
  ];

  # Flanker's tests rely heavily on `nose` which is deprecated and removed from Nixpkgs.
  doCheck = false;

  pythonImportsCheck = [
    "flanker"
    "flanker.addresslib.address"
  ];

  meta = {
    description = "Mailgun Parsing Tools for email addresses and MIME";
    longDescription = ''
      Flanker is an open source parsing library written in Python by the Mailgun Team.
      Flanker currently consists of an address parsing library as well as a MIME parsing library.
    '';
    homepage = "https://github.com/mailgun/flanker";
    changelog = "https://github.com/mailgun/flanker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
