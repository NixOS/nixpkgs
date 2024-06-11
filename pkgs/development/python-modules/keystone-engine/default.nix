{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  keystone,
}:

buildPythonPackage rec {
  pname = "keystone-engine";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xahdr6bh3dw5swrc2r8kqa8ljhqlb7k2kxv5mrw5rhcmcnzcyig";
  };

  setupPyBuildFlags = lib.optionals stdenv.isLinux [
    "--plat-name"
    "linux"
  ];

  preConfigure = ''
    substituteInPlace setup.py --replace \
      "libkeystone" "${keystone}/lib/libkeystone"
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "keystone" ];

  meta = with lib; {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://www.keystone-engine.org";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.gpl2Only;
  };
}
