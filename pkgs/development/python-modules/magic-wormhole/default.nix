{ stdenv
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
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01fr4bi6kc6fz9n3c4qq892inrc3nf6p2djy65yvm7xkvdxncydf";
  };

  buildInputs = [  ];
  propagatedBuildInputs = [ spake2 pynacl six attrs twisted autobahn automat hkdf tqdm click humanize txtorcon ];
  checkInputs = [ mock magic-wormhole-transit-relay magic-wormhole-mailbox-server ];

  postPatch = ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
  '';

  preCheck = ''
    export PATH=$out/bin:$PATH
    substituteInPlace src/wormhole/test/test_cli.py \
      --replace 'getProcessOutputAndValue("locale", ["-a"])' 'getProcessOutputAndValue("locale", ["-a"], env=os.environ)' \
      --replace 'if (os.path.dirname(os.path.abspath(wormhole))' 'if not os.path.abspath(wormhole).startswith("/nix/store") and (os.path.dirname(os.path.abspath(wormhole))' \
  '';

  meta = with stdenv.lib; {
    description = "Securely transfer data between computers";
    homepage = https://github.com/warner/magic-wormhole;
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric ];
  };
}
