{
  lib,
  stdenv,
  fetchgit,
  gnunet,
  qrencode,
  taler-exchange,
  libtool,
  pkg-config,
  autoreconfHook,
  jq,
}:

let
  version = "0.11.3";

  taler-wallet-core = fetchgit {
    url = "https://git.taler.net/wallet-core.git";
    # https://taler.net/fr/news/2024-11.html
    rev = "v0.11.2";
    hash = "sha256-GtR87XqmunYubh9EiY3bJIqXiXrT+re3KqWypYK3NCo=";
  };
in
stdenv.mkDerivation {
  pname = "taler-merchant";
  inherit version;

  src = fetchgit {
    url = "https://git.taler.net/merchant.git";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Rak6p8cuCHPZxrXqrv3YUU3pFFw4GWf8bcd3Ur+o7Wg=";
  };

  postUnpack = ''
    ln -s ${taler-wallet-core}/spa.html $sourceRoot/contrib/
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = taler-exchange.buildInputs ++ [
    qrencode
    taler-exchange
    # for ltdl.h
    libtool
  ];

  propagatedBuildInputs = [ gnunet ];

  # From ./bootstrap
  preAutoreconf = ''
    pushd contrib
    find wallet-core/backoffice/ -type f -printf '  %p \\\n' | sort > Makefile.am.ext
    truncate -s -2 Makefile.am.ext
    cat Makefile.am.in Makefile.am.ext >> Makefile.am
    popd
  '';

  configureFlags = [
    "--with-gnunet=${gnunet}"
    "--with-exchange=${taler-exchange}"
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  nativeCheckInputs = [ jq ];

  checkTarget = "check";

  meta = with lib; {
    description = ''
      This is the GNU Taler merchant backend. It provides the logic that should run
      at every GNU Taler merchant.  The GNU Taler merchant is a RESTful backend that
      can be used to setup orders and process payments.  This component allows
      merchants to receive payments without invading the customers' privacy. Of
      course, this applies mostly for digital goods, as the merchant does not need
      to know the customer's physical address.
    '';
    homepage = "https://taler.net/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.linux;
  };
}
