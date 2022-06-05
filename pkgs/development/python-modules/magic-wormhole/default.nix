{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, spake2
, pynacl
, six
, attrs
, twisted
, autobahn
, automat
, hkdf
, tqdm
, click
, humanize
, txtorcon
, nettools
, mock
, magic-wormhole-transit-relay
, magic-wormhole-mailbox-server
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q41j99718y7m95zg1vaybnsp31lp6lhyqkbv4yqz5ys6jixh3qv";
  };

  propagatedBuildInputs = [
    spake2
    pynacl
    six
    attrs
    twisted
    autobahn
    automat
    hkdf
    tqdm
    click
    humanize
    txtorcon
  ] ++ autobahn.optional-dependencies.twisted
  ++ twisted.optional-dependencies.tls;

  checkInputs = [
    mock
    magic-wormhole-transit-relay
    magic-wormhole-mailbox-server
    twisted
  ];

  postPatch = lib.optionalString stdenv.isLinux ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
  '';

  postInstall = ''
    install -Dm644 docs/wormhole.1 $out/share/man/man1/wormhole.1
  '';

  checkPhase = ''
    export PATH=$out/bin:$PATH
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    substituteInPlace src/wormhole/test/test_cli.py \
      --replace 'getProcessOutputAndValue("locale", ["-a"])' 'getProcessOutputAndValue("locale", ["-a"], env=os.environ)' \
      --replace 'if (os.path.dirname(os.path.abspath(wormhole))' 'if not os.path.abspath(wormhole).startswith("/nix/store") and (os.path.dirname(os.path.abspath(wormhole))' \
      --replace 'locale_env = dict(LC_ALL=locale, LANG=locale)' 'locale_env = dict(LC_ALL=locale, LANG=locale, LOCALE_ARCHIVE=os.getenv("LOCALE_ARCHIVE"))'

    trial -j$NIX_BUILD_CORES wormhole
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/magic-wormhole/magic-wormhole";
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric SuperSandro2000 ];
    mainProgram = "wormhole";
  };
}
