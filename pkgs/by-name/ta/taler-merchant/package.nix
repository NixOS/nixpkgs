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
  makeWrapper,
  jq,
}:

let
  version = "0.12.0";

  taler-wallet-core = fetchgit {
    url = "https://git.taler.net/wallet-core.git";
    # https://taler.net/en/news/2024-23.html
    rev = "v0.12.7";
    hash = "sha256-5fyPPrRCKvHTgipIpKqHX3iH5f+wTuyfsAKgKmvl1nI=";
  };
in
stdenv.mkDerivation {
  pname = "taler-merchant";
  inherit version;

  src = fetchgit {
    url = "https://git.taler.net/merchant.git";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BNIVlL+YPqqRZUhHOR/eH38dSHn/kNyCbMyz0ICxAMk=";
  };

  postUnpack = ''
    ln -s ${taler-wallet-core}/spa.html $sourceRoot/contrib/
  '';

  # Use an absolute path for `templates` and `spa` directories, else a relative
  # path to the `taler-exchange` package is used.
  postPatch = ''
    substituteInPlace src/backend/taler-merchant-httpd.c \
      --replace-fail 'TALER_TEMPLATING_init ("merchant");' "TALER_TEMPLATING_init_path (\"merchant\", \"$out/share/taler\");"

    substituteInPlace src/backend/taler-merchant-httpd_spa.c \
      --replace-fail 'GNUNET_DISK_directory_scan (dn,' "GNUNET_DISK_directory_scan (\"$out/share/taler/merchant/spa/\","
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    makeWrapper
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

  # NOTE: The executables that need database access fail to detect the
  # postgresql library in `$out/lib/taler`, so we need to wrap them.
  postInstall = ''
    for exec in dbinit httpd webhook wirewatch depositcheck exchange; do
      wrapProgram $out/bin/taler-merchant-$exec \
        --prefix LD_LIBRARY_PATH : "$out/lib/taler"
    done
  '';

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
    changelog = "https://git.taler.net/merchant.git/tree/ChangeLog";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ astro ];
    platforms = platforms.linux;
  };
}
