{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  gcc-unwrapped,
}:
buildPythonPackage rec {
  pname = "cxxfilt";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ffZGS6Xo778NiXTAsseLMlRmdvBgWag1FdvfpVmzQhQ=";
  };

  postPatch =
    let
      libstdcpp = "${lib.getLib gcc-unwrapped}/lib/libstdc++${stdenv.hostPlatform.extensions.sharedLibrary}";
    in
    ''
      substituteInPlace cxxfilt/__init__.py \
        --replace "find_any_library('stdc++', 'c++')" '"${libstdcpp}"'
    '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "cxxfilt" ];

  meta = with lib; {
    description = "Demangling C++ symbols in Python / interface to abi::__cxa_demangle ";
    homepage = "https://github.com/afq984/python-cxxfilt";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
