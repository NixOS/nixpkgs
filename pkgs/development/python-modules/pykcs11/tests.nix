{
  buildPythonPackage,
  asn1crypto,
  pykcs11,
  pytestCheckHook,
  softhsm,
}:

buildPythonPackage {
  pname = "pykcs11-tests";
  inherit (pykcs11) version;
  format = "other";

  src = pykcs11.testout;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    asn1crypto
    pykcs11
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PYKCS11LIB=${softhsm}/lib/softhsm/libsofthsm2.so
    export SOFTHSM2_CONF=$HOME/softhsm2.conf
    echo "directories.tokendir = $HOME/tokens" > $HOME/softhsm2.conf
    mkdir $HOME/tokens
    ${softhsm}/bin/softhsm2-util --init-token --label "A token" --pin 1234 --so-pin 123456 --slot 0
  '';
}
