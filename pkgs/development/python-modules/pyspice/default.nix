{ lib, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, libngspice
, numpy
, ply
, scipy
, pyyaml
, cffi
, requests
, matplotlib
, setuptools
}:

buildPythonPackage rec {
  pname = "pyspice";
  version = "1.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PySpice";
    inherit version;
    sha256 = "d28448accad98959e0f5932af8736e90a1f3f9ff965121c6881d24cdfca23d22";
  };

  propagatedBuildInputs = [
    setuptools
    requests
    pyyaml
    cffi
    matplotlib
    numpy
    ply
    scipy
    libngspice
  ];

  doCheck = false;
  pythonImportsCheck = [ "PySpice" ];

  postPatch = ''
    substituteInPlace PySpice/Spice/NgSpice/Shared.py --replace \
        "ffi.dlopen(self.library_path)" \
        "ffi.dlopen('${libngspice}/lib/libngspice${stdenv.hostPlatform.extensions.sharedLibrary}')"
  '';

  meta = with lib; {
    description = "Simulate electronic circuit using Python and the Ngspice / Xyce simulators";
    homepage = "https://github.com/FabriceSalvaire/PySpice";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
