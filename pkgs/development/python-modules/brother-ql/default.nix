{
  fetchPypi,
  buildPythonPackage,
  setuptools,
  future,
  packbits,
  pillow,
  pyusb,
  click,
  attrs,
  jsons,
  lib,
}:

buildPythonPackage rec {
  pname = "brother-ql";
  version = "0.11.2";
  pyproject = true;

  src = fetchPypi {
    pname = "brother_ql_next";
    inherit version;
    hash = "sha256-3rTf+4W5KK7zSGIE3bBHXHE0hjyvpjB0IiEtbax6mkU=";
  };

  propagatedBuildInputs = [
    setuptools
    future
    packbits
    pillow
    pyusb
    click
    attrs
    jsons
  ];

  meta = with lib; {
    description = "Python package for the raster language protocol of the Brother QL series label printers";
    longDescription = ''
      Python package for the raster language protocol of the Brother QL series label printers
      (QL-500, QL-550, QL-570, QL-700, QL-710W, QL-720NW, QL-800, QL-820NWB, QL-1050 and more)
    '';
    homepage = "https://github.com/LunarEclipse363/brother_ql_next";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ grahamc ];
    mainProgram = "brother_ql";
  };
}
