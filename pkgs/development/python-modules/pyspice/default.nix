{ stdenv
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
  pname = "PySpice";
  version = "1.4.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mnyy8nr06d1al99kniyqcm0p9a8dvkg719s42sajl8yf51sayc9";
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

  meta = with stdenv.lib; {
    description = "Simulate electronic circuit using Python and the Ngspice / Xyce simulators";
    homepage = "https://github.com/FabriceSalvaire/PySpice";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
