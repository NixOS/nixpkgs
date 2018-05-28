{ stdenv, fetchPypi, buildPythonPackage, setuptools_scm
, pytest
}:
buildPythonPackage rec {
  pname = "cxxfilt";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mkxiaw8p9vwmk7np63hjnmkb327454jyrg8lcfbwfahmqk1zi3v";
  };


  # see https://github.com/NixOS/nixpkgs/issues/7307
  patchPhase = stdenv.lib.optionalString stdenv.isLinux ''
      substituteInPlace cxxfilt/__init__.py --replace \
        "find_any_library('c')" "'${stdenv.glibc}/lib/libc.so.6'"

      substituteInPlace cxxfilt/__init__.py --replace \
        "find_any_library('c++', 'stdc++')" "'${stdenv.cc.cc.lib}/lib/libstdc++.so.6'"
  '';


  buildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    homepage = https://github.com/afg984/python-cxxfilt;
    description = "Demangling C++ symbols in Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teto ];
  };
}



