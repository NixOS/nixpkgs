{
  lib,
  stdenv,
  fetchgit,
  curl,
  gnunet,
  jansson,
  libgcrypt,
  libmicrohttpd,
  libsodium,
  libunistring,
  pkg-config,
  postgresql,
  autoreconfHook,
  python3,
  recutils,
  wget,
  jq,
  gettext,
  texinfo,
}:

let
  version = "0.12.0";
in
stdenv.mkDerivation {
  pname = "taler-exchange";
  inherit version;

  src = fetchgit {
    url = "https://git.taler.net/exchange.git";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-yHRRMlqFA2OiFg0rBVzn7130wyVaxKn2dChFTPnVtbs=";
  };

  patches = [ ./0001-add-TALER_TEMPLATING_init_path.patch ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libgcrypt
    libmicrohttpd
    jansson
    libsodium
    postgresql
    curl
    recutils
    gettext
    texinfo # Fix 'makeinfo' is missing on your system.
    libunistring
    python3.pkgs.jinja2
    # jq is necessary for some tests and is checked by configure script
    jq
  ];

  propagatedBuildInputs = [ gnunet ];

  # From ./bootstrap
  preAutoreconf = ''
    ./contrib/gana-generate.sh
    pushd contrib
    find wallet-core/aml-backoffice/ -type f -printf '  %p \\\n' | sort > Makefile.am.ext
    truncate -s -2 Makefile.am.ext
    cat Makefile.am.in Makefile.am.ext >> Makefile.am
    popd
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;

  nativeCheckInputs = [
    wget
    curl
  ];

  checkTarget = "check";

  meta = with lib; {
    description = ''
      Taler is an electronic payment system providing the ability to pay
      anonymously using digital cash.  Taler consists of a network protocol
      definition (using a RESTful API over HTTP), a Exchange (which creates
      digital coins), a Wallet (which allows customers to manage, store and
      spend digital coins), and a Merchant website which allows customers to
      spend their digital coins.  Naturally, each Merchant is different, but
      Taler includes code examples to help Merchants integrate Taler as a
      payment system.
    '';
    homepage = "https://taler.net/";
    changelog = "https://git.taler.net/exchange.git/tree/ChangeLog";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.linux;
  };
}
