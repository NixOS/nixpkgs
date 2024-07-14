{
  lib,
  buildPythonPackage,
  fetchPypi,
  keepkey,
  setuptools,
  libagent,
  wheel,
}:

buildPythonPackage rec {
  pname = "keepkey-agent";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "keepkey_agent";
    inherit version;
    hash = "sha256-R8hd4ML/tTxde9L00iMBRqQW6CURJZ+tBRGcTvdL5ww=";
  };

  propagatedBuildInputs = [
    keepkey
    libagent
    setuptools
    wheel
  ];

  doCheck = false;
  pythonImportsCheck = [ "keepkey_agent" ];

  meta = with lib; {
    description = "Using KeepKey as hardware-based SSH/PGP agent";
    homepage = "https://github.com/romanz/trezor-agent";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      hkjn
      np
      mmahut
    ];
  };
}
