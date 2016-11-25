{ fetchurl, lib, buildPythonPackage, python, autobahn
, cffi, click, hkdf, pynacl, spake2, tqdm }:

buildPythonPackage rec {
  name = "magic-wormhole-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://pypi/m/magic-wormhole/${name}.tar.gz";
    sha256 = "1yh5nbhh9z1am2pqnb5qqyq1zjl1m7z6jnkmvry2q14qwspw9had";
  };
  checkPhase = ''
    ${python.interpreter} -m wormhole.test.run_trial wormhole
  '';

  # Several test failures, network related.
  doCheck = false;

  propagatedBuildInputs = [ autobahn cffi click hkdf pynacl spake2 tqdm ];
  meta = {
    description = "Securely transfer data between computers";
    homepage = "https://github.com/warner/magic-wormhole";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ asymmetric ];
  };
}
