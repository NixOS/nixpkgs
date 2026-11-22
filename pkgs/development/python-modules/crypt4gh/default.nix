{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  installShellFiles,
  bats,
  openssh,

  # deps
  cryptography,
  bcrypt,
  pyyaml,
  docopt,
  pynacl,
}:

buildPythonPackage rec {
  pname = "crypt4gh";
  version = "1.7";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "EGA-archive";
    repo = "crypt4gh";
    rev = "v${version}";
    hash = "sha256-kPXD/SityWscHuRn068E6fFxUjt67cC5VEe5o8wtxwk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    docopt
    cryptography
    pynacl
    bcrypt
  ];

  pythonImportsCheck = [ "crypt4gh" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      completions/crypt4gh-debug.bash \
      completions/crypt4gh-debug.bash \
      completions/crypt4gh.bash
  '';

  nativeCheckInputs = [
    bats
    openssh
  ];
  installCheckPhase = ''
    PATH=$PATH:$out/bin
    bats tests
  '';

  meta = {
    mainProgram = "crypt4gh";
    description = "Tool to encrypt, decrypt or re-encrypt files, according to the GA4GH encryption file format";
    homepage = "https://github.com/EGA-archive/crypt4gh";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.richardjacton ];
  };
}
