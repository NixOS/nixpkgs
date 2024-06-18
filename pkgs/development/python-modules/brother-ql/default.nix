{
  stdenv,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
  future,
  packbits,
  pillow,
  pyusb,
  pytest,
  mock,
  click,
  attrs,
  lib,
}:

buildPythonPackage rec {
  pname = "brother-ql";
  version = "0.9.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "brother_ql";
    inherit version;
    hash = "sha256-H1xXoDnwEsnCBDl/RwAB9267dINCHr3phdDLPGFOhmA=";
  };

  propagatedBuildInputs = [
    future
    packbits
    pillow
    pyusb
    click
    attrs
  ];

  patches = [
    (fetchpatch {
      # Make compatible with Pillow>=10.0; https://github.com/pklaus/brother_ql/pull/143
      name = "brother-ql-pillow10-compat.patch";
      url = "https://github.com/pklaus/brother_ql/commit/a7e1b94b41f3a6e0f8b365598bc34fb47ca95a6d.patch";
      hash = "sha256-v3YhmsUWBwE/Vli1SbTQO8q1zbtWYI9iMlVFvz5sxmg=";
    })
  ];

  meta = with lib; {
    description = "Python package for the raster language protocol of the Brother QL series label printers";
    longDescription = ''
      Python package for the raster language protocol of the Brother QL series label printers
      (QL-500, QL-550, QL-570, QL-700, QL-710W, QL-720NW, QL-800, QL-820NWB, QL-1050 and more)
    '';
    homepage = "https://github.com/pklaus/brother_ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ grahamc ];
    mainProgram = "brother_ql";
  };
}
