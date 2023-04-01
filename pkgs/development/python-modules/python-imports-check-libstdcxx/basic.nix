{ lib
, cmake
, pybind11
, buildPythonPackage
, python3
, callPackage
}:

buildPythonPackage {
  pname = "load_libstdcxx";
  version = "0.0.1";

  format = "other";

  src = lib.sourceFilesBySuffices ./. [ ".txt" ".cc" ];

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    pybind11
  ];

  cmakeFlags = [
    "-DLOAD_LIBSTDCXX_INSTALL_SITE_PACKAGES=${placeholder "out"}/${python3.sitePackages}"
  ];

  pythonImportsCheck = [
    "load_libstdcxx"
  ];

  meta = with lib; {
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ SomeoneSerge ];
  };

}
