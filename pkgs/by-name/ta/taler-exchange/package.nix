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
  libpq,
  autoreconfHook,
  python3,
  recutils,
  wget,
  jq,
  gettext,
  texinfo,
  libtool,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taler-exchange";
  version = "1.0.4";

  src = fetchgit {
    url = "https://git.taler.net/exchange.git";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-k2e9pzy7vSIjCVGOVif9ntYvLcvoJA6J63vB/lg3iwA=";
  };

  patches = [ ./0001-add-TALER_TEMPLATING_init_path.patch ];

  nativeBuildInputs = [
    autoreconfHook
    recutils # recfix
    pkg-config
    python3.pkgs.jinja2
    texinfo # makeinfo
    # jq is necessary for some tests and is checked by configure script
    jq
  ];

  buildInputs = [
    libgcrypt
    libmicrohttpd
    jansson
    libsodium
    libpq
    libtool
    curl
    gettext
    libunistring
  ];

  strictDeps = true;

  propagatedBuildInputs = [ gnunet ];

  # From ./bootstrap
  preAutoreconf = ''
    ./contrib/gana-generate.sh
    pushd contrib
    rm -f Makefile.am
    {
      echo 'dist_amlspapkgdata_DATA = \'
      find wallet-core/aml-backoffice/ -type f | sort | awk '{print "  " $1 " \\" }'
    }  >> Makefile.am.ext
    # Remove extra '\' at the end of the file
    truncate -s -2 Makefile.am.ext

    {
      echo ""
      echo 'dist_kycspapkgdata_DATA = \'
      find wallet-core/kyc/ -type f | sort | awk '{print "  " $1 " \\" }'
    }  >> Makefile.am.ext
    # Remove extra '\' at the end of the file
    truncate -s -2 Makefile.am.ext

    {
      echo ""
      echo 'dist_auditorspapkgdata_DATA = \'
      find wallet-core/auditor-backoffice/ -type f | sort | awk '{print "  " $1 " \\" }'
    }  >> Makefile.am.ext
    # Remove extra '\' at the end of the file
    truncate -s -2 Makefile.am.ext

    cat Makefile.am.in Makefile.am.ext >> Makefile.am
    # Prevent accidental editing of the generated Makefile.am
    chmod -w Makefile.am
    popd
  '';

  configureFlags = [
    "ac_cv_path__libcurl_config=${lib.getDev curl}/bin/curl-config"
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  nativeCheckInputs = [
    wget
    curl
  ];

  checkTarget = "check";

  passthru.tests = nixosTests.taler.basic;

  meta = {
    description = "Exchange component for the GNU Taler electronic payment system";
    longDescription = ''
      Taler is an electronic payment system providing the ability to pay
      anonymously using digital cash.  Taler consists of a network protocol
      definition (using a RESTful API over HTTP), an Exchange (which creates
      digital coins), a Wallet (which allows customers to manage, store and
      spend digital coins), and a Merchant website which allows customers to
      spend their digital coins.  Naturally, each Merchant is different, but
      Taler includes code examples to help Merchants integrate Taler as a
      payment system.
    '';
    homepage = "https://taler.net/";
    changelog = "https://git.taler.net/exchange.git/tree/ChangeLog";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ astro ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.linux;
  };
})
