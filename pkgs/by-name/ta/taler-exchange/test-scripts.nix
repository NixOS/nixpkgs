{
  runCommand,
  taler-exchange,

  callPackage,
}:
runCommand "taler-exchange-test-scripts"
  {
    inherit (taler-exchange) src;
    nativeBuildInputs = [
      taler-exchange
      taler-exchange.terms
      # FIX: remove after https://github.com/NixOS/nixpkgs/pull/357535
      (callPackage ./sphinx.nix { })
    ];
  }
  ''
    # NOTE:
    # - taler-exchange-kyc-persona-converter.sh: works, but requires internet for downloading image
    # - taler-exchange-kyc-kycaid-converter: untested, requires Authentication token
    # - taler-audit: untested, requires exchange setup

    set -ex

    HOME="$(mktemp -d)"
    export TALER_HOME="$HOME/.config"
    export TALER_CONF="$TALER_HOME/taler.conf"

    export TERMS_DIR="$TALER_HOME/terms"
    export LOCALEDIR="$TALER_HOME/locale"

    mkdir -p "$TERMS_DIR" "$LOCALEDIR"
    install \
      -D "$src/contrib/locale/de/LC_MESSAGES/exchange-tos-v0.po" \
      -t "$LOCALEDIR/de/LC_MESSAGES"

    touch "$TALER_CONF"
    taler-config -c "$TALER_CONF" -s taler -o currency -V KUDOS
    taler-config -c "$TALER_CONF" -s PATHS -o LOCALEDIR -V "$LOCALEDIR"
    taler-config -c "$TALER_CONF" -s exchange -o TERMS_DIR -V "$TERMS_DIR"

    taler-terms-generator \
      -L "$LOCALEDIR" \
      -o "$TERMS_DIR" \
      -i "$src/contrib/exchange-tos-v0.rst"

    for script in taler-exchange-helper-measure-test-{form,oauth}; do
        echo '{"attributes": {"full_name":"", "birthdate":""}}' | $script
    done

    for script in taler-exchange-kyc-oauth2-{nda,test-converter}.sh; do
        echo '{"status":"success", "data":{"id":"","last_name":"","first_name":"","phone":""}}' | $script
    done

    echo '{"full_name":"", "birthdate":""}' | taler-exchange-helper-converter-oauth2-test-full_name
    echo '{"pep":false}' | taler-exchange-kyc-aml-pep-trigger.sh
    echo '{"id":"", "address":"", "address_type":"email","address_expiration":""}' | taler-exchange-kyc-oauth2-challenger.sh
    echo '{"included": [{"type":"verification/government-id", "attributes":{"status":"passed", "front-photo-url":""}}]}' | taler-exchange-kyc-persona-converter.sh

    mkdir $out
    echo success > $out/${taler-exchange.version}
  ''
