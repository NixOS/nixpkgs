{ lib
, buildPythonPackage
, fetchPypi
, gcc-unwrapped
}:
buildPythonPackage rec {
  pname = "cxxfilt";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef6810e76d16c95c11b96371e2d8eefd1d270ec03f9bcd07590e8dcc2c69e92b";
  };

  postPatch = ''
    substituteInPlace cxxfilt/__init__.py \
      --replace "find_any_library('stdc++', 'c++')" '"${lib.getLib gcc-unwrapped}/lib/libstdc++.so"'
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [
    "cxxfilt"
  ];

  meta = with lib; {
    description = "Demangling C++ symbols in Python / interface to abi::__cxa_demangle ";
    homepage = "https://github.com/afq984/python-cxxfilt";
    license = licenses.bsd2;
    maintainers = teams.determinatesystems.members;
  };
}
