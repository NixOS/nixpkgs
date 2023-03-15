{ lib
, buildPythonPackage
, fetchPypi
, keepkey
, setuptools
, libagent
, wheel
}:

buildPythonPackage rec {
  pname = "keepkey_agent";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03779gvlx70i0nnry98i4pl1d92604ix5x6jgdfkrdgzqbh5vj27";
  };

  propagatedBuildInputs = [
    keepkey libagent setuptools wheel
  ];

  doCheck = false;
  pythonImportsCheck = [ "keepkey_agent" ];

  meta = with lib; {
    description = "Using KeepKey as hardware-based SSH/PGP agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hkjn np mmahut ];
  };
}
