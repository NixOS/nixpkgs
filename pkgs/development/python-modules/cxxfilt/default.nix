{ lib, buildPythonPackage, fetchPypi, libcxx }:

buildPythonPackage rec {
  pname = "cxxfilt";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0az9d4ncr38fb43wv6rzq072f7gxxvcf4wb3p48mrj8ndpki0s7g";
  };

  postPatch = ''
    substituteInPlace ./cxxfilt/__init__.py \
      --replace "find_any_library('stdc++', 'c++')" "\"${libcxx}/lib/libc++.so.1\""
  '';

  meta = with lib; {
    description = "Demangling C++ symbols in Python / interface to abi::__cxa_demangle";
    homepage = "https://github.com/afq984/python-cxxfilt";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
