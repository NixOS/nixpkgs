{ lib
, buildPythonPackage
, fetchFromGitHub
, gnupg
, keyring
, pass
, poetry-core
, pythonOlder
}:
buildPythonPackage rec {
  pname = "keyring-pass";
  version = "0.9.2";
  disabled = pythonOlder "3.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "nazarewk";
    repo = "keyring_pass";
    rev = "refs/tags/v${version}";
    hash = "sha256-Sf7eDOB3prH2s6BzdBtxewSweC0ibLXVxNHBJRRaJe4=";
  };

  postPatch = ''
    substituteInPlace keyring_pass/__init__.py \
      --replace 'pass_binary = "pass"' 'pass_binary = "${lib.getExe pass}"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    keyring
    gnupg
  ];

  checkPhase = ''
    export HOME="$TMPDIR"

    # generate temporary GPG identity
    cat <<EOF | gpg --gen-key --batch /dev/stdin
    %no-protection
    %transient-key
    Key-Type: 1
    Key-Length: 1024
    Subkey-Type: 1
    Subkey-Length: 1024
    Name-Real: test
    Name-Email: test@example.com
    Expire-Date: 1
    EOF

    # configure password store
    ${lib.getExe pass} init test@example.com

    # Configure `keyring` CLI
    # first make sure `keyring-pass` is in "$PYTHONPATH"
    [[ "$PYTHONPATH" == *"$out"/lib/python*/site-packages* ]]
    export PYTHON_KEYRING_BACKEND="keyring_pass.PasswordStoreBackend"

    # confirm set/get/del works
    keyring set test-service test-username <<<"test-password"
    test "$(keyring get test-service test-username)" == "test-password"
    keyring del test-service test-username
  '';

  pythonImportsCheck = [
    "keyring_pass"
  ];

  meta = {
    description = "Password Store (pass) backend for python's keyring";
    homepage = "https://github.com/nazarewk/keyring_pass";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nazarewk ];
  };
}
