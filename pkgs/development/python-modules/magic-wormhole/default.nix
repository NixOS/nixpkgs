{ lib
, buildPythonPackage
, fetchPypi
, nettools
, glibcLocales
, autobahn
, cffi
, click
, hkdf
, pynacl
, spake2
, tqdm
, python
, mock
}:

buildPythonPackage rec {
  pname = "magic-wormhole";
  version = "0.8.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yh5nbhh9z1am2pqnb5qqyq1zjl1m7z6jnkmvry2q14qwspw9had";
  };

  checkInputs = [ mock ];
  buildInputs = [ nettools glibcLocales ];
  propagatedBuildInputs = [ autobahn cffi click hkdf pynacl spake2 tqdm ];

  postPatch = ''
    sed -i -e "s|'ifconfig'|'${nettools}/bin/ifconfig'|" src/wormhole/ipaddrs.py
    sed -i -e "s|if (os.path.dirname(os.path.abspath(wormhole))|if not os.path.abspath(wormhole).startswith('/nix/store') and (os.path.dirname(os.path.abspath(wormhole))|" src/wormhole/test/test_scripts.py
    # XXX: disable one test due to warning:
    # setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
    sed -i -e "s|def test_text_subprocess|def skip_test_text_subprocess|" src/wormhole/test/test_scripts.py
  '';

  checkPhase = ''
    export PATH="$PATH:$out/bin"
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    ${python.interpreter} -m wormhole.test.run_trial wormhole
  '';

  meta = with lib; {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/warner/magic-wormhole";
    license = licenses.mit;
    maintainers = with maintainers; [ asymmetric ];
  };
}
