{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, rtl-sdr
, m2r
}:

buildPythonPackage rec {
  pname = "pyrtlsdr";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7942fe2e7821d09206002ea7e820e694094b3f964885123eb6eee1167f39b8da";
  };

  # Replace pypandoc dependency by m2r
  # See https://github.com/roger-/pyrtlsdr/pull/78
  patches = [
    (fetchpatch {
      url = "${meta.homepage}/commit/2b7df0b.patch";
      sha256 = "04h5z80969jgdgrf98b9ps56sybms09xacvmj6rwcfrmanli8rgf";
    })
    (fetchpatch {
      url = "${meta.homepage}/commit/97dc3d0.patch";
      sha256 = "1v1j0n91jwpsiam2j34yj71z4h39cvk4gi4565zgjrzsq6xr93i0";
    })
  ];

  nativeBuildInputs = [ m2r ];

  postPatch = ''
    sed "s|driver_files =.*|driver_files = ['${rtl-sdr}/lib/librtlsdr.so']|" -i rtlsdr/librtlsdr.py
  '';

  # No tests that can be used.
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for librtlsdr (a driver for Realtek RTL2832U based SDR's)";
    homepage = https://github.com/roger-/pyrtlsdr;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
