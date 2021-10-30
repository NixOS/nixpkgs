{ lib, stdenv, fetchFromGitHub, cmake, boost165, openssl, zlib, gcc9
}:



stdenv.mkDerivation {
  pname = "libcpprestsdk";
  version = "2.10.18";
  buildInputs = [
    boost165 openssl zlib
  ];
  nativeBuildInputs = [
    cmake gcc9
  ];
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "cpprestsdk";
    rev = "2.10.18";
    sha256 = "07qyip57wyzpmlgyz1fri4ljmla7ar3isddvfkm8hzv6q35bx2rn";
    fetchSubmodules = true;
  };
  meta = {
    description = "Cloud-based client-server communication in native code using a modern asynchronous C++ API design";
    homepage = "https://github.com/Microsoft/cpprestsdk";
    license = lib.licenses.mit;
    maintainers = [ "retonlage <retonlage@retonlage.xyz>" ];
  };
}
